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

  def draw(renderer, %Ball{} = ball) do
    draw_circle(renderer, ball.x, ball.y, Ball.radius)
  end

  def draw(renderer, paddle) do
    struct = paddle.__struct__
    draw_rect(renderer, paddle.x, paddle.y, struct.width, struct.height)
  end

  defp draw_rect(renderer, x, y, width, height) do
    :ok = set_color(renderer, 255, 255, 255)
    :ok = :sdl_renderer.fill_rect(renderer, %{x: x, y: y, w: width, h: height})
  end

  defp draw_circle(renderer, x, y, radius) do
    # Offset x and y by the radius when rendering
    #points = midpoint_circle([], x0 + radius, radius, y0 + radius, 0, 0)
    :ok = set_color(renderer, 255, 255, 255)
    :ok = :sdl_renderer.draw_circle(renderer, x + radius, y + radius, radius)
  end

  defp set_color(renderer, r, g, b) do
    :ok = :sdl_renderer.set_draw_color(renderer, r, g, b, 255)
  end
end
