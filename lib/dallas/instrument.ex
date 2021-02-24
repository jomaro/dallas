defmodule Dallas.Instrument do

  @spec get_all_instruments :: list
  def get_all_instruments() do
    for {module, _} <- :code.all_loaded(),
      __MODULE__ in get_behaviours_for_module(module) do
      module
    end
  end

  def get_whitelisted_instruments() do
    Application.get_env(:dallas, :whitelisted_instruments) || get_all_instruments()
  end
  def get_whitelisted_instruments(type) do
    get_whitelisted_instruments()
    |> Enum.filter(fn instrument -> instrument.instrument_type == type end)
  end

  defp get_behaviours_for_module(module) do
    module.module_info(:attributes)
    |> Keyword.get_values(:behaviour)
    |> List.flatten()
  end

  defp get_source_link(module) do
    module
    |> Atom.to_string()
    |> String.replace(".", "/")
    |> Macro.underscore()
  end


  @callback measure() :: [Dallas.Measurement.t()]

  defmacro wrap_instrument(_env) do
    quote do
      defoverridable measure: 0

      def measure do
        super()
        |> List.wrap()
        |> Enum.map(fn measurement ->
          %{
            measurement
            | instrument: __MODULE__,
              execution_date: measurement.execution_date || DateTime.utc_now(),
              actions: [{"go to source", "#"} | measurement.actions],
          }
        end)
      end
    end
  end

  defmacro __using__(_opts) do
    quote do
      @behaviour Dallas.Instrument

      def instrument_type, do: :general

      defoverridable(instrument_type: 0)

      @before_compile {Dallas.Instrument, :wrap_instrument}
    end
  end
end
