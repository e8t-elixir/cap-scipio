defmodule Scipio.Server do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello Plug")
  end
end
