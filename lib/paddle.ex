defmodule Paddle do
  @height 100
  @width 10
  @vel 5
  @wall_offset 10

  defstruct [:x, :y]

  def render(renderer, %Paddle{} = paddle) do
    :ok = :sdl_renderer.set_draw_color(renderer, 255, 255, 255, 255)
    :ok = :sdl_renderer.fill_rect(renderer, %{x: paddle.x, y: paddle.y, w: @width, h: @height})
  end

  def init("left", _, screen_height) do
    %Paddle{x: @wall_offset, y: init_y(screen_height)}
  end

  def init("right", screen_width, screen_height) do
    %Paddle{x: screen_width - @width - @wall_offset, y: init_y(screen_height)}
  end

  def init_y(screen_height) do
    round((screen_height / 2) - (@height / 2))
  end

  def update_y(%Paddle{} = paddle) do
    Map.update!(paddle, :y, &(&1 + @vel))
  end
end
