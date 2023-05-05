defmodule UpLearn.Adapter.Request do
  @callback get(url :: String.t(), headers :: list) :: String.t()

  def get(url, headers \\ []), do: impl().get(url, headers)

  defp impl(), do: Application.get_env(:up_learn, :http_adapter)
end
