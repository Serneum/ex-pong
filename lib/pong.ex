defmodule Pong do
  use Application
  alias Pong.Game
  @game_interval 15

  def start(_type, _args) do
    {:ok, game} = Game.start_link
    Process.register(game, :game)
    :timer.send_interval(@game_interval, game, :tick)
    spawn(fn() -> Pong.Sdl.Window.start(game) end)
    Pong.Supervisor.start_link
  end
end

