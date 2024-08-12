defmodule Campsite.Web.HomeView do

  @template_path "lib/campsite/web/templates"

  def render(name, assigns) do
    try do
      EEx.eval_file("#{@template_path}/#{name}.eex", assigns)
    rescue
      e in CompilerError ->
        details = Enum.reduce(Map.from_struct(e), "", fn {k, v}, acc -> acc <> "#{k}:#{v}" end)
        "<h1>This is an error #{details}</h1>"
    end
  end
end
