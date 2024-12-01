# Dallas

This is a simple monitoring tool most fitting for business monitoring.

It works as a platform inside a phoenix application to periodically run
your instruments and display then on the screen.

## Installation

1. If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dallas` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dallas, "~> 0.1.0"}
  ]
end
```

2. Add `dallas_dashboard "/dallas"` to your `router.ex` file.

Example:

```elixir
  scope "/", ExampleWeb do
    pipe_through :browser

    get "/", PageController, :home

    dallas_dashboard "/dallas"
  end
```

3. Write your own instruments

```elixir
defmodule YourProject.Instruments.MyInstrument do
  use Dallas.Instrument, queue: :default

  alias Dallas.Measurement

  def measure do
    # do whatever you want, REALLY, whatever

    # hit APIs, query databases, does not matter

    # just return a list (or one) of Dallas.Measurement structs

    %Measurement{
      path: "Organize/Folders/Whoever/Is/Most/Convenient",
      level: :ok, # or :warning, or :error
      value: "ok"
    }
  end
end
```
