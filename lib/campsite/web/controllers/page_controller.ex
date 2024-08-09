defmodule Campsite.Web.PageController do
  import Plugs.Conn

  @template_path "lib/campsite/web/templates"

  def call(conn, action) do
    apply(__MODULE__, action, [conn, "controller here"])
    content_for(conn.req_path, conn)
  end

  defp content_for("/", conn) do
    put_resp_body(conn, "<h1>This is a thing</h1>")
  end

  def home(conn, msg) do
    IO.inspect(conn)
    put_resp_body(conn, "<h1>Welcome #{msg}</h1>")
  end

#   def contact(conn, _) do
#     put_resp_body(conn, "This is a contact us page")
#   end

#   defp other(conn, %{:path => path}) do
#     name = Path.basename(path)
#     if Enum.member?(get_templates(), name) do
#       render(conn, name)
#     else
#       not_found(conn, name)
#     end
#   end

#   defp not_found(conn, route) do
#     conn
#     |> put_status(404)
#     |> put_resp_body("<h1>oops route #{route} doesn't exist</h1>")
#   end

#   def render(conn, name) do
#     assigns = Enum.to_list(conn.assigns)
#     try do
#       body = EEx.eval_file("#{@template_path}/#{name}.eex", assigns)
#       put_resp_body(conn, body)
#     rescue
#       e in CompilerError ->
#         details = Enum.reduce(Map.from_struct(e), "", fn {k, v}, accum -> acc <> "#{k}:#{v}" end)
#         put_resp_body(conn, "<h1>This is an error #{details}</h1>")
#     end
#   end

#   defp get_templates do
#     for t <- Path.wildcard("#{@template_path}/*.eex"),
#      do: Path.basename(t, ".eex")
#   end
end
