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
    :ok = draw_lines(renderer, x0 + radius, radius, y0 + radius, 0, 0)

    # Draw all points contained within a circle
    # points = get_fill_points_outer(x0, x0 + radius, y0, y0 + radius, radius)
    # :ok = :sdl_renderer.draw_points(renderer, points)

    # Draw a series of smaller circles to fill a larger circle
    # draw_circles(renderer, x0, y0, radius, 1)

    # Fill a circle determined by midpoint-circle
    # points = fill_midpoint_circle(x0 + radius, radius, 1 - (radius * 2), y0 + radius, 0, 0, 0)
    # :ok = :sdl_renderer.draw_points(renderer, points)

    # Fill using an alg from StackOverflow. Single-loop version of get_fill_points_outer
    # points = single_loop(x0 + radius, y0 + radius, radius)
    # :ok = :sdl_renderer.draw_points(renderer, points)
  end

  # Draw a series of smaller circles to fill a larger circle
  defp draw_circles(renderer, x, y, radius, curr_radius) when curr_radius <= radius do
    points = midpoint_circle(x + radius, curr_radius, y + radius, 0, 0)
    :ok = :sdl_renderer.draw_points(renderer, points)
    draw_circles(renderer, x, y, radius, curr_radius + 1)
  end

  defp draw_circles(_, _, _, _, _), do: :ok

  # Draw all points contained within a circle
  defp get_fill_points_outer(x, xCenter, y, yCenter, radius) when x <= xCenter do
    get_fill_points_inner(x, xCenter, y, yCenter, radius) ++ get_fill_points_outer(x + 1, xCenter, y, yCenter, radius)
  end

  defp get_fill_points_outer(_, _, _, _, _), do: []

  defp get_fill_points_inner(x, xCenter, y, yCenter, radius) when y <= yCenter do
    get_fill_points(x, xCenter, y, yCenter, radius) ++ get_fill_points_inner(x, xCenter, y + 1, yCenter, radius)
  end

  defp get_fill_points_inner(_, _, _, _, _), do: []

  defp get_fill_points(x, xCenter, y, yCenter, radius) when (x - xCenter) * (x - xCenter) + (y - yCenter) * (y - yCenter) < radius * radius do
    xSym = xCenter - (x - xCenter)
    ySym = yCenter - (y - yCenter)
    [%{x: x, y: y}, %{x: x, y: ySym}, %{x: xSym, y: y}, %{x: xSym, y: ySym}]
  end

  defp get_fill_points(_, _, _, _, _), do: []

  # Draw lines between points from the midpoint-cirlce algorithm to fill the circle
  defp draw_lines(renderer, x0, x, y0, y, err) when x >= y do
    :sdl_renderer.draw_line(renderer, %{x: x0 + x, y: y0 + y}, %{x: x0 - x, y: y0 + y})
    :sdl_renderer.draw_line(renderer, %{x: x0 + y, y: y0 + x}, %{x: x0 - y, y: y0 + x})
    :sdl_renderer.draw_line(renderer, %{x: x0 - x, y: y0 - y}, %{x: x0 + x, y: y0 - y})
    :sdl_renderer.draw_line(renderer, %{x: x0 - y, y: y0 - x}, %{x: x0 + y, y: y0 - x})

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

  # Fill using midpoint cirlce algorithm
  defp fill_midpoint_circle(x0, x, x_change, y0, y, y_change, err) when x >= y do
    points = fill_midpoint_circle_get_x_points(x0, x, y0, y, x0 - x) ++ fill_midpoint_circle_get_y_points(x0, x, y0, y, x0 - y)
    |> Enum.uniq

    new_y = y + 1
    tmp_err = err + y_change
    new_y_change = y_change + 2
    values = fill_midpoint_circle_update_values(x, x_change, tmp_err)

    points ++ fill_midpoint_circle(x0, values.x, values.x_change, y0, new_y, new_y_change, values.err)
  end

  defp fill_midpoint_circle(_, _, _, _, _, _, _) do
    []
  end

  defp fill_midpoint_circle_get_x_points(x0, x, y0, y, iter) when iter <= x0 + x do
    [%{x: iter, y: y0 + y}, %{x: iter, y: y0 - y}] ++ fill_midpoint_circle_get_x_points(x0, x, y0, y, iter + 1)
  end

  defp fill_midpoint_circle_get_x_points(_, _, _, _, _) do
    []
  end

  defp fill_midpoint_circle_get_y_points(x0, x, y0, y, iter) when iter <= x0 + y do
    [%{x: iter, y: y0 + x}, %{x: iter, y: y0 - x}] ++ fill_midpoint_circle_get_y_points(x0, x, y0, y, iter + 1)
  end

  defp fill_midpoint_circle_get_y_points(_, _, _, _, _) do
    []
  end

  defp fill_midpoint_circle_update_values(x, x_change, err) when 2 * err + x_change > 0 do
    new_x = x - 1
    new_err = err + x_change
    new_x_change = x_change + 2
    %{x: new_x, x_change: new_x_change, err: new_err}
  end

  defp fill_midpoint_circle_update_values(x, x_change, err) do
    %{x: x, x_change: x_change, err: err}
  end

  # Single loop solution (http://stackoverflow.com/a/24453110)
  defp single_loop(x, y, radius) do
    [%{x: x, y: y}] ++ single_loop_points(x, y, radius, 0)
  end

  defp single_loop_points(x, y, radius, iter) when iter <= (radius * radius * 4) do
    diameter = radius * 2

    tx = round((rem iter, diameter) - radius)
    ty = round((iter / diameter) - radius)
    points = if (tx * tx + ty * ty < radius * radius) do
      [%{x: x + tx, y: y + ty}]
    else
      []
    end

    points ++ single_loop_points(x, y, radius, iter + 1)
  end

  defp single_loop_points(_, _, _, _) do
    []
  end

  defp set_color(renderer, r, g, b) do
    :ok = :sdl_renderer.set_draw_color(renderer, r, g, b, 255)
  end
end
