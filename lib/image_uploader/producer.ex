defmodule ImageUploader.Producer do
  use GenStage
  alias ImageUploader.ConsumerSupervisor
  alias ImageUploader.Consumer

  @name __MODULE__

  def start_link(state) do
    GenStage.start_link(@name, state, name: @name)
  end

  def add(event) do
    GenStage.cast(@name, {:add, event})
  end

  def init(state) do
    send(self(), :start_consumer)
    {:producer, state}
  end

  def handle_cast({:add, event}, state) do
    {:noreply, [event], state}
  end

  def handle_demand(demand, state) when demand > 0 do
    {images, state} = Enum.split(state, demand)
    {:noreply, images, state}
  end

  def handle_info(:start_consumer, state) do
    for _ <- 1..check_pool_size() do
      {:ok, _} = ConsumerSupervisor.start_consumer(ConsumerSupervisor, Consumer)
    end

    {:noreply, [], state}
  end

  defp check_pool_size() do
    # Here would be a check on the quantity of consumers needed depending on the demand
    # but due time I couldn't reach the final solution.
    3
  end
end
