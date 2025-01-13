defmodule Dallas.Measurement do

  @type t :: %__MODULE__{
    path: String.t(),
    level: atom(),
    detail: String.t(),
    value: any(),
    instrument: atom(),
    execution_date: DateTime.t(),
    actions: list()
  }

  defstruct [
    :path,
    :level,
    :detail,
    :value,
    :instrument,
    :execution_date,
    actions: [],
  ]
end
