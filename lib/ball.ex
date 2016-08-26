defmodule Ball do
  @height 50
  @width 50

  defstruct [:x, :y, :x_vel, :y_vel]

  def render(renderer, ball) do
    :ok = :sdl_renderer.set_draw_color(renderer, 255, 255, 255, 255)
    :ok = :sdl_renderer.fill_rect(renderer, %{x: get_x(ball), y: get_y(ball), w: @width, h: @height})
  end

  def get_x(ball) do
    Map.get(ball, :x)
  end

  def get_x_vel(ball) do
    Map.get(ball, :x_vel)
  end

  def get_y(ball) do
    Map.get(ball, :y)
  end

  def get_y_vel(ball) do
    Map.get(ball, :y_vel)
  end

  def update_x(ball, screen_width) do
    x = get_x(ball)
    x_vel = get_x_vel(ball)
    Map.get_and_update(ball, :x, fn val -> {val, check_bounds(x, x_vel, @width, screen_width)} end) |> elem(1)
  end

  def update_y(ball, screen_height) do
    y = get_y(ball)
    y_vel = get_y_vel(ball)
    Map.get_and_update(ball, :y, fn val -> {val, check_bounds(y, y_vel, @height, screen_height)} end) |> elem(1)
  end

  def update_x_vel(ball, screen_width) do
    x = get_x(ball)
    x_vel = get_x_vel(ball)
    Map.get_and_update(ball, :x_vel, fn val -> {val, check_vel(x, x_vel, @width, screen_width)} end) |> elem(1)
  end

  def update_y_vel(ball, screen_height) do
    y = get_y(ball)
    y_vel = get_y_vel(ball)
    Map.get_and_update(ball, :y_vel, fn val -> {val, check_vel(y, y_vel, @height, screen_height)} end) |> elem(1)
  end

  def check_bounds(val, vel, _, _) when val + vel < 0 do
    0
  end

  def check_bounds(val, vel, size, limit) when val + vel + size >= limit do
    limit - size
  end

  def check_bounds(val, vel, _, _) do
    val + vel
  end

  def check_vel(val, vel, _, _) when val <= 0 and vel <= 0 do
    rand_vel
  end

  def check_vel(val, vel, size, limit) when val + size >= limit and vel >= 0 do
    rand_vel * -1
  end

  def check_vel(_, vel, _, _) do
    vel
  end

  def rand_vel do
    :rand.uniform(5) - 1
  end
end
