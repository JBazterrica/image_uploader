defmodule ImageUploader.Endpoint do
  alias ImageUploader.Controllers.ImageUpload
  use Plug.Router

  plug(Plug.Logger)

  plug(:match)

  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])

  plug(:dispatch)

  post "/image" do
    case conn.body_params do
      %{"device_id" => device_id, "image" => image} ->
        ImageUpload.upload(conn, {device_id, image})

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(:bad_request, Poison.encode!(%{response: "Bad params!"}))
    end
  end

  match _ do
    conn
    |> send_resp(:not_found, "")
  end
end
