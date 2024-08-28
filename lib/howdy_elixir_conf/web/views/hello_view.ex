defmodule HowdyElixirConf.Web.HelloView do
  @template_path "lib/howdy_elixir_conf/web/templates"

  def render(conn, name, assigns) do
    try do
      body = EEx.eval_file("#{@template_path}/#{name}_view.eex", assigns)
      conn
      |> Plug.Conn.resp(200, body)
    rescue
      e in CompileError ->
        conn
        |> Plug.Conn.resp(404, "An error was found #{e}")
    end
  end
end
