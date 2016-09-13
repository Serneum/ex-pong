defmodule Pong.Sdl.Window do
  @moduledoc """

  Begin an SDL window to render a Pong game

  """

  @title 'Pong - SDL'
  @width 500
  @height 500
  @refresh_interval 15

  alias Pong.Game
  alias Pong.Sdl.Renderer

  def start(game) do
    init(game)
  end

  def init(game) do
    :ok = :sdl.start([:video])
    :ok = :sdl.stop_on_exit()
    renderer = Renderer.draw_window('Pong', @width, @height)
    :timer.send_interval(@refresh_interval, self, :tick)
    loop(game, renderer)
    terminate
  end

  def loop(game, renderer) do
    state = Game.get_state(game)
    case :sdl_events.poll do
      false -> :ok
      %{type: :quit} -> terminate
      _ -> loop(game, renderer)
    end

    receive do
      :tick ->
        Renderer.draw(state, renderer)
        loop(game, renderer)
      event ->
        loop(state, renderer)
    end
  end

  defp terminate do
    :init.stop
    exit(:normal)
  end
end

