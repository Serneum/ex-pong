defmodule Pong.Game.Interaction do
  alias Pong.Game.Paddle
  alias Pong.Game.State

  def handle_input(original_state, event) do
    do_handle_input(original_state, event)
    # cond do
    #   valid?(new_state) -> new_state
    #  true -> original_state
    # end
  end

  def do_handle_input(state, key) when key == 26 or key == 82 do
    paddle = Map.get(state, :p1)
    |> Paddle.update_y(:up)
    %State{state | p1: paddle}
  end

  def do_handle_input(state, key) when key == 22 or key == 81 do
    paddle = Map.get(state, :p1)
    |> Paddle.update_y(:down)
    %State{state | p1: paddle}
  end

  def do_handle_input(state, _), do: state

  # defp valid?(state) do
  #   !out_of_bounds?(state)
  # end
end
