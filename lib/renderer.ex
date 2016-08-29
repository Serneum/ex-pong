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
    draw_circle(renderer, ball.x, ball.y, round(Ball.width / 2))
  end

  def draw(renderer, paddle) do
    struct = paddle.__struct__
    draw_rect(renderer, paddle.x, paddle.y, struct.width, struct.height)
  end

  defp draw_rect(renderer, x, y, width, height) do
    :ok = set_color(renderer, 255, 255, 255)
    :ok = :sdl_renderer.fill_rect(renderer, %{x: x, y: y, w: width, h: height})
  end

  defp draw_circle(renderer, x0, y0, radius) do
    points = midpoint_circle([], x0, radius, y0, 0, 0)
    :ok = set_color(renderer, 255, 255, 255)
    :ok = :sdl_renderer.draw_points(renderer, points)
  end

  defp midpoint_circle(points, x0, x, y0, y, err) when x >= y do
    points = points
    |> List.insert_at(-1, %{x: x0 + x, y: y0 + y})
    |> List.insert_at(-1, %{x: x0 + y, y: y0 + x})
    |> List.insert_at(-1, %{x: x0 - y, y: y0 + x})
    |> List.insert_at(-1, %{x: x0 - x, y: y0 + y})
    |> List.insert_at(-1, %{x: x0 - x, y: y0 - y})
    |> List.insert_at(-1, %{x: x0 - y, y: y0 - x})
    |> List.insert_at(-1, %{x: x0 + y, y: y0 - x})
    |> List.insert_at(-1, %{x: x0 + x, y: y0 - y})

    new_y = y + 1
    tmp_err = err + 1 + (2 * new_y)
    values = midpoint_circle_update_values(x, tmp_err)

    midpoint_circle(points, x0, values.x, y0, new_y, values.err)
  end

  defp midpoint_circle(points, _, _, _, _, _) do
    points
  end

  defp midpoint_circle_update_values(x, err) when 2 * (err - x) + 1 > 0 do
    new_x = x - 1
    new_err = err + 1 - (2 * new_x)
    %{x: new_x, err: new_err}
  end

  defp midpoint_circle_update_values(x, err) do
    %{x: x, err: err}
  end

  defp set_color(renderer, r, g, b) do
    :ok = :sdl_renderer.set_draw_color(renderer, r, g, b, 255)
  end
end
