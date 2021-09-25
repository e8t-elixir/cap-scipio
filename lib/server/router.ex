defmodule Scipio.Server.Router do
  use Plug.Router
  require Logger

  plug Plug.Parsers, parsers: [:json],
                     pass: ["text/*"],
                     json_decoder: Jason
  plug :match
  plug :dispatch

  get "/hello" do
    send_resp(conn, 200, "Plug running")
  end

  post "/test" do
    render_json(conn, %{message: "Thank you!"})
  end

  post "/run_pipeline" do
    IO.inspect(conn.params, label: "run_pipeline")
    
    case conn.params do
      %{"pipelines" => task_names} ->
        Task.async(Scipio.Start, :run, [task_names |> Enum.map(fn item -> s_to_a(item) end)])
        render_json(conn, %{message: "Start pipelines"})
      _ ->
        Logger.warn("no pipelines section")
        render_json(conn, %{message: "Thank you!"})
    end
    # TODO: where handle the list, here or in Start module
    # render_json(conn, %{message: "Thank you!"})
  end

  # resume
  # stop
  # kill
  # https://stackoverflow.com/questions/13033527/pausing-suspending-entire-erlang-program

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp render_json(%{status: status} = conn, data) do
    body = Jason.encode!(data)
    send_resp(conn, (status || 200), body)
  end

  defp s_to_a(string) do
    try do
      string |> String.to_existing_atom()
    rescue
      e in ArgumentError ->
        Logger.warn("#{inspect(e)} non-existing atom")
        nil
    end
  end
end

# curl -X POST http://localhost:9000/test
