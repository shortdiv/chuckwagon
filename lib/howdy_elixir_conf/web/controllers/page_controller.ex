defmodule HowdyElixirConf.Web.PageController do
  import Plugs.Conn

  @template_path "lib/howdy_elixir_conf/web/templates"

  def call(conn, action, opts \\ []) do
    apply(__MODULE__, action, [conn, opts])
  end

  def home(conn, _) do
    render(conn, "home")
  end

  def two(conn, _) do
    render(conn, "two")
  end

  def not_matched(conn, %{:path => path}) do
    name = Path.basename(path)
    if Enum.member?(get_templates(), name) do
      render(conn, name)
    else
      not_found(conn, name)
    end
  end

  defp not_found(conn, route) do
    conn
    |> put_status(404)
    |> put_resp_body("<h1>oops route #{route} doesn't exist</h1>")
  end

  def render(conn, name) do
    assigns = Enum.to_list(conn.assigns)
    try do
      body = EEx.eval_file("#{@template_path}/#{name}.eex", assigns)
      put_resp_body(conn, body)
    rescue
      e in CompilerError ->
        details = Enum.reduce(Map.from_struct(e), "", fn {k, v}, acc -> acc <> "#{k}:#{v}" end)
        put_resp_body(conn, "<h1>This is an error #{details}</h1>")
    end
  end

  defp get_templates do
    for t <- Path.wildcard("#{@template_path}/*.eex"),
     do: Path.basename(t, ".eex")
  end
end
