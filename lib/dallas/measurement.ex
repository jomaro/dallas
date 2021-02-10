defmodule Dallas.Measurement do

  defstruct [
    :path,
    :level,
    :detail,
    :value,
    :instrument,
    actions: [],
  ]
end
