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

  defp draw_circle(renderer, x0, y0, radius) do
    :ok = set_color(renderer, 255, 255, 255)
    # Offset x and y by the radius when rendering

    # Use midpoint-circle algorithm
    # points = midpoint_circle(x0 + radius, radius, y0 + radius, 0, 0)
    # :ok = :sdl_renderer.draw_points(renderer, points)

    # Draw lines between points from the midpoint-cirlce algorithm to fill the circle
    # ok = draw_lines(renderer, x0 + radius, radius, y0 + radius, 0, 0)

    # Draw all points contained within a circle
    points = get_fill_points_outer(x0, x0 + radius, y0, y0 + radius, radius)
    :ok = :sdl_renderer.draw_points(renderer, points)

    # Draw a series of smaller circles to fill a larger circle
    # draw_circles(renderer, x0, y0, radius, 1)
  end

  # Draw a series of smaller circles to fill a larger circle
  defp draw_circles(renderer, x, y, radius, curr_radius) when curr_radius <= radius do
    points = midpoint_circle(x + radius, curr_radius, y + radius, 0, 0)
    :ok = :sdl_renderer.draw_points(renderer, points)
    draw_circles(renderer, x, y, radius, curr_radius + 1)
  end

  defp draw_circles(_, _, _, _, _) do
    :ok
  end

  # Draw all points contained within a circle
  defp get_fill_points_outer(x, xCenter, y, yCenter, radius) when x <= xCenter do
    get_fill_points_inner(x, xCenter, y, yCenter, radius) ++ get_fill_points_outer(x + 1, xCenter, y, yCenter, radius)
  end

  defp get_fill_points_outer(_, _, _, _, _) do
    []
  end

 defp get_fill_points_inner(x, xCenter, y, yCenter, radius) when y <= yCenter do
    get_fill_points(x, xCenter, y, yCenter, radius) ++ get_fill_points_inner(x, xCenter, y + 1, yCenter, radius)
  end

  defp get_fill_points_inner(_, _, _, _, _) do
    []
  end

 defp get_fill_points(x, xCenter, y, yCenter, radius) when (x - xCenter) * (x - xCenter) + (y - yCenter) * (y - yCenter) < radius * radius do
    xSym = xCenter - (x - xCenter)
    ySym = yCenter - (y - yCenter)
    [%{x: x, y: y}, %{x: x, y: ySym}, %{x: xSym, y: y}, %{x: xSym, y: ySym}]
  end

  defp get_fill_points(_, _, _, _, _) do
    []
  end

  # Draw lines between points from the midpoint-cirlce algorithm to fill the circle
  defp draw_lines(renderer, x0, x, y0, y, err) when x >= y do
    :sdl_renderer.draw_line(renderer, %{x: x0 + x, y: y0 + y}, %{x: x0 - x, y: y0 - y})
    :sdl_renderer.draw_line(renderer, %{x: x0 + y, y: y0 + x}, %{x: x0 - y, y: y0 - x})
    :sdl_renderer.draw_line(renderer, %{x: x0 - y, y: y0 + x}, %{x: x0 + y, y: y0 - x})
    :sdl_renderer.draw_line(renderer, %{x: x0 - x, y: y0 + y}, %{x: x0 + x, y: y0 - y})

    new_y = y + 1
    tmp_err = err + 1 + (2 * new_y)
    values = midpoint_circle_update_values(x, tmp_err)

    draw_lines(renderer, x0, values.x, y0, new_y, values.err)
  end

  defp draw_lines(_, _, _, _, _, _) do
    :ok
  end

  # Use midpoint-circle algorithm to get the points for the outline of a circle
  defp midpoint_circle(x0, x, y0, y, err) when x >= y do
    points = [%{x: x0 + x, y: y0 + y}, %{x: x0 + y, y: y0 + x}, %{x: x0 - y, y: y0 + x}, %{x: x0 - x, y: y0 + y},
              %{x: x0 - x, y: y0 - y}, %{x: x0 - y, y: y0 - x}, %{x: x0 + y, y: y0 - x}, %{x: x0 + x, y: y0 - y}]
    |> Enum.uniq

    new_y = y + 1
    tmp_err = err + 1 + (2 * new_y)
    values = midpoint_circle_update_values(x, tmp_err)

    points ++ midpoint_circle(x0, values.x, y0, new_y, values.err)
  end

  defp midpoint_circle(_, _, _, _, _) do
    []
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
