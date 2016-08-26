defmodule Pong do
  @height 50
  @width 50
  @limit 500

  def start do
    :ok = :sdl.start([:video])
    :ok = :sdl.stop_on_exit
    {:ok, window} = :sdl_window.create('Hello SDL', 10, 10, @limit, @limit, [])
    {:ok, renderer} = :sdl_renderer.create(window, -1, [:accelerated, :present_vsync])
    loop(renderer, 100, 100, rand_vel, rand_vel)
  end

  def loop(renderer, x, y, x_vel, y_vel) do
    :ok = :sdl_renderer.set_draw_color(renderer, 0, 0, 0, 255)
    :ok = :sdl_renderer.clear(renderer)
    :ok = :sdl_renderer.set_draw_color(renderer, 255, 255, 255, 255)
    :ok = :sdl_renderer.fill_rect(renderer, %{x: x, y: y, w: @width, h: @height})
    :ok = :sdl_renderer.present(renderer)

    case :sdl_events.poll do
      %{type: :quit} -> :erlang.terminate
      _ -> new_x = new_coord(x, x_vel, @width)
           new_y = new_coord(y, y_vel, @height)
           loop(renderer, new_x, new_y, reverse_vel(new_x, x_vel, @width), reverse_vel(new_y, y_vel, @height))
    end
  end

  def new_coord(val, vel, size) do
    min_val = val + vel
    max_val = val + vel + size
    cond do
      min_val < 0 ->
        0
      max_val >= @limit ->
        @limit - size
      true ->
        val + vel
    end
  end

  def reverse_vel(val, vel, size) do
    cond do
      val <= 0 ->
        if vel <= 0 do
          rand_vel
        else
          vel
        end
      val + size >= @limit ->
        if vel >= 0 do
          rand_vel * -1
        else
          vel
        end
      true ->
        vel
    end
  end

  def rand_vel do
    :rand.uniform(5) - 1
  end
end

Pong.start
