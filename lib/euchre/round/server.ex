defmodule Euchre.Round.Server do
  @moduledoc false

  use GenServer

  def start_link(id) do
    GenServer.start_link(__MODULE__, [], name: Euchre.Application.via_tuple(id))
  end

  def init(_) do
    {:ok, []}
  end
end
