defmodule ValorisWeb.CommonHelpers do
  def on_page?(conn, path) do
    current_path = Path.join(["/" | conn.path_info])
    path == current_path
  end
end
