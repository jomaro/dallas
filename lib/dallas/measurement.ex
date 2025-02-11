defmodule Dallas.Measurement do
  @type t :: %__MODULE__{
          path: String.t(),
          level: atom(),
          detail: String.t(),
          value: any(),
          unit: any(),
          instrument: atom(),
          execution_date: DateTime.t(),
          actions: list()
        }

  defstruct [
    :path,
    :level,
    :detail,
    :value,
    :unit,
    :instrument,
    :execution_date,
    actions: []
  ]
end
