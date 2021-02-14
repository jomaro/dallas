defmodule Dallas.Measurement do

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
