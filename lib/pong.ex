defmodule Pong do
  @height 500
  @width 500

  def start do
    :ok = :sdl.start([:video])
    :ok = :sdl.stop_on_exit
    {:ok, window} = :sdl_window.create('Pong', 10, 10, @width, @height, [])
    {:ok, renderer} = :sdl_renderer.create(window, -1, [:accelerated, :present_vsync])

    p1 = Paddle.init("left", @width, @height)
    p2 = AIPaddle.init(@width, @height)
    ball = %Ball{x: 100, y: 100, x_vel: Ball.rand_vel, y_vel: Ball.rand_vel}

    objects = [p1, p2, ball]
    loop(renderer, objects)
  end

  def loop(renderer, objects) do
    :ok = :sdl_renderer.set_draw_color(renderer, 0, 0, 0, 255)
    :ok = :sdl_renderer.clear(renderer)

    # TODO: Create a Renderer module. Objects should each have a type
    # that determines which render method to call (?)
    for obj <- objects, do: :ok = obj.__struct__.render(renderer, obj)
    :ok = :sdl_renderer.present(renderer)

    case :sdl_events.poll do
      %{type: :quit} -> :erlang.terminate
      _ ->
          ball = objects
          |> List.last
          |> Ball.update_x(@width)
          |> Ball.update_y(@height)
          |> Ball.update_x_vel(@width)
          |> Ball.update_y_vel(@height)

          ai_paddle = objects
          |> Enum.at(1)
          |> AIPaddle.move_paddle(ball, @width)

          objects = objects
          |> List.replace_at(1, ai_paddle)
          |> List.replace_at(2, ball)
          loop(renderer, objects)
    end
  end
end

Pong.start
