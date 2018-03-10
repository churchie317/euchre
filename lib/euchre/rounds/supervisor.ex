defmodule Euchre.Rounds.Supervisor do
  @moduledoc false

  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(id) do
    DynamicSupervisor.start_child(__MODULE__, {Euchre.Round.Server, id})
  end

  def stop_child(id) do
    [{supervisor_pid, _value}] = Registry.lookup(:euchre_registry, id)
    DynamicSupervisor.terminate_child(__MODULE__, supervisor_pid)
  end
end
