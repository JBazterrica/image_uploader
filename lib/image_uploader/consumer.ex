defmodule ImageUploader.Consumer do
  use GenStage
  require Logger

  @name __MODULE__
  @min_demand 5
  @max_demand 10

  def start_link(_opts) do
    GenStage.start_link(@name, :state)
  end

  def init(state) do
    {:consumer, state,
     subscribe_to: [
       {ImageUploader.Producer, min_demand: @min_demand, max_demand: @max_demand}
     ]}
  end

  def handle_events(events, _from, state) do
    for _event <- events do
      Logger.info("Uploading to AWS...")
      Process.sleep(1_000)
      Logger.info("Image Successfully Uploaded!")
    end

    {:noreply, [], state}
  end
end
