defmodule ImageUploader.Controllers.ImageUpload do
  alias ImageUploader.Producer

  def upload(conn, {device_id, %Plug.Upload{path: file_path}}) do
    {:ok, image} = File.read(file_path)
    Producer.add({device_id, image})

    conn
    |> Plug.Conn.send_resp(:accepted, "")
  end
end
