defmodule ImageUploader.ConsumerSupervisor do
  use DynamicSupervisor

  @name __MODULE__

  def start_link(_args) do
    DynamicSupervisor.start_link(@name, :ok, name: @name)
  end

  defdelegate start_consumer(sup, spec), to: DynamicSupervisor, as: :start_child

  def init(:ok) do
    opts = [strategy: :one_for_one]
    DynamicSupervisor.init(opts)
  end
end
