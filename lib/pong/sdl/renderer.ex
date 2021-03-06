defmodule Pong.Sdl.Renderer do
  alias Pong.Game.Ball

  def draw(state, renderer) do
    clear_screen(renderer)
    do_draw(state, renderer)
  end

  def clear_screen(renderer) do
    :ok = set_color(renderer, 0, 0, 0)
    :ok = :sdl_renderer.clear(renderer)
  end

  def do_draw(state, renderer) do
    draw_frame(renderer, state)
    render_screen(renderer)
  end

  def draw_frame(renderer, state) do
    draw_object(renderer, Map.get(state, :p1))
    draw_object(renderer, Map.get(state, :p2))
    draw_object(renderer, Map.get(state, :ball))
  end

  def render_screen(renderer) do
    :ok = :sdl_renderer.present(renderer)
  end

  def draw_window(name, width, height) do
    {:ok, window} = :sdl_window.create(name, 10, 10, width, height, [])
    {:ok, renderer} = :sdl_renderer.create(window, -1, [:accelerated, :present_vsync])
    renderer
  end

  defp draw_object(renderer, %Ball{} = ball) do
    draw_circle(renderer, ball.x, ball.y, Ball.radius)
  end

  defp draw_object(renderer, paddle) do
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
    :ok = :sdl_renderer.fill_circle(renderer, %{x: x + radius, y: y + radius, r: radius})
  end

  defp set_color(renderer, r, g, b) do
    :ok = :sdl_renderer.set_draw_color(renderer, r, g, b, 255)
  end
end

