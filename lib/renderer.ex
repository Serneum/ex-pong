defmodule Renderer do

  def clear_screen(renderer) do
    :ok = set_color(renderer, 0, 0, 0)
    :ok = :sdl_renderer.clear(renderer)
  end

  def render_screen(renderer) do
    :ok = :sdl_renderer.present(renderer)
  end

  def draw_window(name, width, height) do
    {:ok, window} = :sdl_window.create(name, 10, 10, width, height, [])
    {:ok, renderer} = :sdl_renderer.create(window, -1, [:accelerated, :present_vsync])
    renderer
  end

  # Not a huge fan of needing to have the module structs contain width/height
  # Seemed like the easiest way to get the data, though
  def draw(renderer, %{x: x, y: y, width: w, height: h}) do
    :ok = set_color(renderer, 255, 255, 255)
    :ok = :sdl_renderer.fill_rect(renderer, %{x: x, y: y, w: w, h: h})
  end

  def set_color(renderer, r, g, b) do
    :ok = :sdl_renderer.set_draw_color(renderer, r, g, b, 255)
  end
end
