# Dallas

A simple generic monitoring and alert system.


### What does it do?

There is for now a single concept working is this project, 
the concept of `instrument`

A instrument is a module suposedly inside the `lib/dallas/instruments`
that implements a `measure` method, and this function return a list of
`%Dallas.Measurement{}` structs. 

The measurement has a `:path` entry that you should use as a `/` 
separated scope identifier of that result. Dallas will then collect
all measurements with the same namespace and display them as one
hierarchical structure is the screen.


One example of instrument and it's result on screen:

```Elixir
defmodule Dallas.Instrument.Dummy do

  alias Dallas.Measurement

  def measure do
    [
      %Measurement{
        path: "Dummy/the ok one",
        level: :ok,
        value: "OK",
        detail: "Nothing to see here",
      },
      %Measurement{
        path: "Dummy/the nok one",
        level: :error,
        value: "Wrong",
        detail: "Something went wrong here",
      },
      %Measurement{
        path: "missplaced",
        level: :ok,
        value: "OK",
        detail: "this guy is missplaced on the root, who did this?",
      },
    ]
  end

end
```

#### Root screen

![root node](https://github.com/jomaro/dallas/blob/master/github/dummy_root.png?raw=true)

#### On the `/Dummy` subpath

![root node](https://github.com/jomaro/dallas/blob/master/github/dummy_dummy_subpath.png?raw=true)

#### On the `/Dummy/the nok one` leaf node

![root node](https://github.com/jomaro/dallas/blob/master/github/dummy_leaf_node.png?raw=true)




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
