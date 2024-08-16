defmodule Giddyup.Conn do
  # we have to adapt?
  @behaviour Plug.Conn.Adapter

  def conn(req) do
    %{
      path: path,
      host: host,
      port: port,
      method: method,
      headers: headers,
      qs: qs,
      peer: {remote_ip, _}
    } = req

    %Plug.Conn{
      adapter: {__MODULE__, req},
      host: host,
      method: method,
      owner: self(),
      path_info: split_path(path),
      port: port,
      remote_ip: remote_ip,
      query_string: qs,
      req_headers: to_headers_list(headers),
      request_path: path,
      scheme: String.to_atom(:cowboy_req.scheme(req))
    }
  end

  @impl true
  def chunk(req, body) do
    :cowboy_req.stream_body(body, :nofin, req)
  end

  @impl true
  def get_http_protocol(req) do
    :cowboy_req.version(req)
  end

  # helpers
  defp to_headers_list(headers) when is_list(headers) do
    headers
  end

  defp to_headers_list(headers) when is_map(headers) do
    :maps.to_list(headers)
  end

  @impl true
  def get_peer_data(data) do
    %{peer: {ip, port}, cert: cert} = data
    %{
      address: ip,
      port: port,
      ssl_cert: if(cert == :undefined, do: nil, else: cert)
    }
  end

  @impl true
  def inform(req, status, _headers) do
    # add headers to req somehow?
    :cowboy_req.inform(status, %{}, req)
  end

  @impl true
  def push(req, path, _headers) do
    :cowboy_req.push(path, %{}, req, %{})
  end

  @impl true
  def read_req_body(req, opts) do
    :cowboy_req.read_body(req, opts)
  end

  @impl true
  def send_chunked(req, status, headers) do
    req = :cowboy_req.stream_reply(status, req)
    {:ok, nil, req}
  end

  @impl true
  def send_file(req, status, _headers, path, offset, length) do
    %File.Stat{type: :regular, size: size} = File.stat!(path)
    body = {:sendfile, offset, length}
    :cowboy_req.reply(status, %{}, body, req)
    {:ok, nil, req}
  end

  @impl true
  def send_resp(req, status, _headers, body) do
    IO.puts("sented???")
    req = :cowboy_req.reply(status, %{}, body, req)
    {:ok, nil, req}
  end

  @impl true
  def upgrade(req, protocol, opts) do
    {:ok, Map.put(req, :upgrade, {protocol, opts})}
  end

  # https://github.com/elixir-plug/plug/blob/main/lib/plug/conn/adapter.ex#L36
  defp split_path(path) do
    segments = :binary.split(path, "/", [:global])
    for segment <- segments, segment != "", do: segment
  end

end
