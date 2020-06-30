defmodule ImageUploader.Application do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: ImageUploader.Endpoint,
        options: Application.get_env(:image_uploader, :endPoint)[:port]
      ),
      ImageUploader.Producer,
      ImageUploader.ConsumerSupervisor
    ]

    opts = [strategy: :one_for_one, name: ImageUploader.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
