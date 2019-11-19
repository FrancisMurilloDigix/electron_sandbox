defmodule SecpEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :secp_ex,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:blockchain, "~> 0.1.7"},
      {:exth_crypto, "~> 0.1.4"},
      # {:libsecp256k1, "~> 0.1.9"},
      # {:libsecp256k1, git: "https://github.com/DigixGlobal/libsecp256k1.git", branch: "fix/freebsd", override: true},
      # {:keccakf1600, "~> 2.0.0", override: true}
    ]  ++
      bsd_deps()
  end

  defp bsd_deps do
    case :os.type() do
      {:unix, type} when type in [:freebsd, :openbsd] ->
        [
          {:eleveldb, "2.2.20", override: true, compile: "rebar compile"},
          {:keccakf1600, git: "https://github.com/DigixGlobal/erlang-keccakf1600.git", branch: "fix/freebsd", override: true}
        ]

      _ ->
        [{:eleveldb, "2.2.20", manager: :rebar3}]
    end
  end
end
