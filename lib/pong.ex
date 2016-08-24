defmodule Pong do
  def start do
    :ok = :sdl.start([:video])
    :ok = :sdl.stop_on_exit
    {:ok, window} = :sdl_window.create('Hello SDL', 10, 10, 500, 500, [])
    {:ok, renderer} = :sdl_renderer.create(window, -1, [:accelerated, :present_vsync])
    loop(renderer, 100, 100, rand_vel, rand_vel)
  end

  def loop(renderer, x, y, x_vel, y_vel) do
    :ok = :sdl_renderer.set_draw_color(renderer, 0, 0, 0, 255)
    :ok = :sdl_renderer.clear(renderer)
    :ok = :sdl_renderer.set_draw_color(renderer, 255, 255, 255, 255)
    :ok = :sdl_renderer.fill_rect(renderer, %{x: x, y: y, w: 50, h: 50})
    :ok = :sdl_renderer.present(renderer)
    case :sdl_events.poll do
      %{type: :quit} -> :erlang.terminate
      _ -> new_x = x + x_vel
           new_y = y + y_vel
           loop(renderer, new_x, new_y, reverse_vel(new_x + 50, 500, x_vel), reverse_vel(new_y + 50, 500, y_vel))
    end
  end

  def reverse_vel(val, limit, vel) do
    if val <= 0 || val >= limit do
      if vel < 0 do
        rand_vel
      else
        rand_vel * -1
      end
    else
      vel
    end
  end

  def rand_vel do
    :rand.uniform(5) - 1
  end
end

Pong.start
