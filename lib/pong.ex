defmodule Pong do
  @height 500
  @width 500

  def start do
    :ok = :sdl.start([:video])
    :ok = :sdl.stop_on_exit

    renderer = Renderer.draw_window('Pong', @width, @height)
    p1 = Paddle.init("left", @width, @height)
    p2 = AIPaddle.init(@width, @height)
    ball = %Ball{x: 100, y: 100, x_vel: Ball.rand_vel, y_vel: Ball.rand_vel}

    objects = [p1, p2, ball]
    loop(renderer, objects)
  end

  def loop(renderer, objects) do
    Renderer.clear_screen(renderer)
    for obj <- objects, do: :ok = Renderer.draw(renderer, obj)
    Renderer.render_screen(renderer)

    case event = :sdl_events.poll do
      %{type: :quit} -> :erlang.terminate
      # %{type: :mouse_motion} ->
      %{type: :key_down} ->
        paddle = objects
        |> List.first
        |> Paddle.update_y(event.scancode)

        objects = objects
        |> List.replace_at(0, paddle)
        loop(renderer, objects)
      _ ->
        objects = update_objects(objects)
        loop(renderer, objects)
    end
  end

  defp update_objects(objects) do
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

    objects
  end
end

Pong.start
