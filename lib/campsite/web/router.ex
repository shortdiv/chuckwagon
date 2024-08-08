defmodule Campsite.Web.Router do
  import Plugs.Conn

  @template_path "lib/campsite/web/templates"

  def call(conn) do
    content_for(conn.req_path, conn)
  end

  defp content_for("/", conn) do
    put_resp_body(conn, "<h1>This is the base content</h1>")
  end

  defp content_for("/2", conn) do
    put_resp_body(conn, "<h1>This is the second base</h1>")
  end

  defp content_for(not_matched, conn) do
    name = Path.basename(not_matched)
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
    conn = assign(conn, :adj, "great!")
    assigns = Enum.to_list(conn.assigns)
    body = EEx.eval_file("#{@template_path}/#{name}.eex", assigns)
    put_resp_body(conn, body)
  end

  defp get_templates do
    for t <- Path.wildcard("#{@template_path}/*.eex"),
     do: Path.basename(t, ".eex")
  end
end
