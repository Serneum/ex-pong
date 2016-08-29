defmodule Paddle do
  @height 100
  @width 10
  @vel 5
  @wall_offset 10

  defstruct x: nil, y: nil, width: @width, height: @height

  def init("left", _, screen_height) do
    %Paddle{x: @wall_offset, y: init_y(screen_height)}
  end

  def init("right", screen_width, screen_height) do
    %Paddle{x: screen_width - @width - @wall_offset, y: init_y(screen_height)}
  end

  def update_y(%Paddle{} = paddle) do
    Map.update!(paddle, :y, &(&1 + @vel))
  end

  defp init_y(screen_height) do
    round((screen_height / 2) - (@height / 2))
  end
end
