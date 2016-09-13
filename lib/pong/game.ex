defmodule Pong.Game do
  use GenServer

  alias Pong.Game.AIPaddle
  alias Pong.Game.Ball
  alias Pong.Game.Interaction
  alias Pong.Game.Paddle
  alias Pong.Game.State

  @width 500
  @height 500

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def stop(pid) do
    GenServer.cast(pid, :stop)
  end

  def tick(pid) do
    GenServer.cast(pid, :tick)
  end

  def handle_input(pid, input) do
    GenServer.cast(pid, {:handle_input, input})
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  ## Server Callbacks

  def init(:ok) do
    p1 = Paddle.init("left", @width, @height)
    p2 = AIPaddle.init(@width, @height)
    ball = Ball.init(@width, @height)

    {:ok, %State{p1: p1, p2: p2, ball: ball}}
  end

  def handle_cast(:stop, _state) do
    {:stop, :normal, :shutdown_ok, []}
  end

  def handle_cast(:tick, state) do
    {:noreply, tick_game(state)}
  end

  def handle_cast({:handle_input, input}, state) do
    {:noreply, Interaction.handle_input(state, input)}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:tick, state) do
    {:noreply, tick_game(state)}
  end

  def tick_game(state) do
    ball = Map.get(state, :ball)
    |> Ball.update_x(@width)
    |> Ball.update_y(@height)
    |> Ball.update_x_vel(@width)
    |> Ball.update_y_vel(@height)

    ai_paddle = Map.get(state, :p2)
    |> AIPaddle.move_paddle(ball, @width)

    %State{state | p2: ai_paddle, ball: ball}
  end
end

