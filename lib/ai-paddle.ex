defmodule AIPaddle do
  @height 100
  @width 10
  @vel 5
  @wall_offset 10

  defstruct x: nil, y: nil, width: @width, height: @height

  def init(screen_width, screen_height) do
    %Paddle{x: screen_width - @width - @wall_offset, y: init_y(screen_height)}
  end

  def init_y(screen_height) do
    round((screen_height / 2) - (@height / 2))
  end

  def move_paddle(%Paddle{} = paddle, %Ball{x: b_x, x_vel: b_x_vel} = ball, screen_width) when b_x_vel > 0 and b_x > round(screen_width / 2) do
    p_center = paddle.y + round(@height / 2)
    update_y(paddle, ball.y, p_center)
  end

  def move_paddle(%Paddle{} = paddle, _, _) do
    paddle
  end

  defp update_y(%Paddle{} = paddle, b_y, p_center) when p_center < (b_y - 35) do
    Map.update!(paddle, :y, &(&1 + @vel))
  end

  defp update_y(%Paddle{} = paddle, b_y, p_center) when p_center > (b_y + 35) do
    Map.update!(paddle, :y, &(&1 - @vel))
  end

  defp update_y(%Paddle{} = paddle, _, _) do
    paddle
  end
end
