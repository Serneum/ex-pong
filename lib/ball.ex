defmodule Ball do
  @height 10
  @width 10

  defstruct x: nil, y: nil, x_vel: nil, y_vel: nil, width: @width, height: @height

  def rand_vel do
    :rand.uniform(5) - 1
  end

  def update_x(%Ball{} = ball, screen_width) do
    Map.update!(ball, :x, &(check_bounds(&1, ball.x_vel, @width, screen_width)))
  end

  def update_y(%Ball{} = ball, screen_height) do
    Map.update!(ball, :y, &(check_bounds(&1, ball.y_vel, @height, screen_height)))
  end

  def update_x_vel(%Ball{} = ball, screen_width) do
    Map.update!(ball, :x_vel, &(check_vel(ball.x, &1, @width, screen_width)))
  end

  def update_y_vel(%Ball{} = ball, screen_height) do
    Map.update!(ball, :y_vel, &(check_vel(ball.y, &1, @height, screen_height)))
  end

  defp check_bounds(val, vel, _, _) when val + vel < 0 do
    0
  end

  defp check_bounds(val, vel, size, limit) when val + vel + size >= limit do
    limit - size
  end

  defp check_bounds(val, vel, _, _) do
    val + vel
  end

  defp check_vel(val, vel, _, _) when val <= 0 and vel <= 0 do
    rand_vel
  end

  defp check_vel(val, vel, size, limit) when val + size >= limit and vel >= 0 do
    rand_vel * -1
  end

  defp check_vel(_, vel, _, _) do
    vel
  end
end
