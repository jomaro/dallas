# Dallas

A simple generic monitoring and alert system.


## Roadmap

 - [x] screen working
 - [ ] schedulers
 - [ ] screen to monitor running instruments
 - [ ] monitoring for instruments that broke


## How to extend (not working)


```Elixir
defmodule Dallas.Instrument.Your.Instrument do
  use Dallas.Instrument

  alias Dallas.Measurement

  def measure do
    
    # 
    # do whatever you want here
    # you just need to return a Measurement or a list of these
    # 

    [
      %Measurement{
        path: "Your/instrument/one",
        level: :ok,
      }
    ]
  end
end
```


## How to run

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).


## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
