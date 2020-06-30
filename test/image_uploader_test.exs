defmodule ImageUploaderTest do
  use ExUnit.Case
  use Plug.Test
  alias ImageUploader.Endpoint
  doctest ImageUploader

  @root_dir File.cwd!()
  @folder_path "#{@root_dir}/test/test_pic.jpg"
  @opts Endpoint.init([])

  test "greets the world" do
    assert ImageUploader.hello() == :world
  end

  test "successful aws upload" do
    # Create a test connection
    conn =
      conn(:post, "/image", [
        {"device_id", 1},
        {"image",
         %Plug.Upload{
           path: @folder_path
         }}
      ])

    conn = Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 202
    assert conn.resp_body == ""
  end
end
