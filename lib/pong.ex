defmodule Pong do
  @height 500
  @width 500

  def start do
    :ok = :sdl.start([:video])
    :ok = :sdl.stop_on_exit
    {:ok, window} = :sdl_window.create('Hello SDL', 10, 10, @width, @height, [])
    {:ok, renderer} = :sdl_renderer.create(window, -1, [:accelerated, :present_vsync])

    ball = %Ball{x: 100, y: 100, x_vel: Ball.rand_vel, y_vel: Ball.rand_vel}
    loop(renderer, ball)
  end

  def loop(renderer, ball) do
    :ok = :sdl_renderer.set_draw_color(renderer, 0, 0, 0, 255)
    :ok = :sdl_renderer.clear(renderer)
    :ok = Ball.render(renderer, ball)
    :ok = :sdl_renderer.present(renderer)

    case :sdl_events.poll do
      %{type: :quit} -> :erlang.terminate
      _ -> ball = Ball.update_x(ball, @width)
           |> Ball.update_y(@height)
           |> Ball.update_x_vel(@width)
           |> Ball.update_y_vel(@height)
           loop(renderer, ball)
    end
  end
end

Pong.start
