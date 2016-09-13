defmodule Pong.Game.Ball do
  alias Pong.Game.Ball

  @radius 10
  @vel 5

  defstruct [:x, :y, :x_vel, :y_vel]

  def radius, do: @radius
  def diameter, do: @radius * 2

  def init(screen_width, screen_height) do
    angle = rand_angle
    %Ball{x: round(screen_width / 2) - radius, y: round(screen_height / 2) - radius,
      x_vel: round(rand_vel * :math.cos(angle)), y_vel: round(rand_vel * :math.sin(angle))}
  end

  def rand_angle do
    # Get a value between -25 and 25
    differential = Enum.random([-1, 1]) * round(:rand.uniform * 25)
    # Get a multiplier between 0 and 3
    multiplier = :rand.uniform(4) - 1
    # Get an angle between 20 and 70 degrees in any of the four quadrants
    degrees = (45 + differential) + (90 * multiplier)
    degrees * (:math.pi / 180)
  end

  def rand_vel do
    Enum.random([-1, 1]) * @vel
  end

  def update_x(%Ball{} = ball, screen_width) do
    Map.update!(ball, :x, &(check_bounds(&1, ball.x_vel, diameter, screen_width)))
  end

  def update_y(%Ball{} = ball, screen_height) do
    Map.update!(ball, :y, &(check_bounds(&1, ball.y_vel, diameter, screen_height)))
  end

  def update_x_vel(%Ball{} = ball, screen_width) do
    Map.update!(ball, :x_vel, &(check_vel(ball.x, &1, diameter, screen_width)))
  end

  def update_y_vel(%Ball{} = ball, screen_height) do
    Map.update!(ball, :y_vel, &(check_vel(ball.y, &1, diameter, screen_height)))
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
