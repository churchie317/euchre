defmodule Euchre.Application do
  @moduledoc false

  @registry_name :euchre_registry

  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: @registry_name},
      {Euchre.Rounds.Supervisor, nil}
    ]

    opts = [strategy: :rest_for_one, name: Euchre.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def via_tuple(process_name) do
    {:via, Registry, {@registry_name, process_name}}
  end
end
