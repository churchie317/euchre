defmodule Euchre.Round.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    opts = [strategy: :one_for_one]
    Supervisor.init([{Euchre.Round.Server, nil}], opts)
  end
end
