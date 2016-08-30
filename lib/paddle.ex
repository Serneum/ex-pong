defmodule Paddle do
  @height 100
  @width 10
  @vel 15
  @wall_offset 10

  defstruct [:x, :y]

  def width, do: @width
  def height, do: @height

  def init("left", _, screen_height) do
    %Paddle{x: @wall_offset, y: init_y(screen_height)}
  end

  def init("right", screen_width, screen_height) do
    %Paddle{x: screen_width - @width - @wall_offset, y: init_y(screen_height)}
  end

  # When pressing W (26) or Up (82)
  def update_y(%Paddle{} = paddle, key) when key == 26 or key == 82 do
    Map.update!(paddle, :y, &(&1 - @vel))
  end

  # When pressing S (22) or Down (81)
  def update_y(%Paddle{} = paddle, key) when key == 22 or key == 81 do
    Map.update!(paddle, :y, &(&1 + @vel))
  end

  def update_y(%Paddle{} = paddle, _) do
    paddle
  end

  defp init_y(screen_height) do
    round((screen_height / 2) - (@height / 2))
  end
end
