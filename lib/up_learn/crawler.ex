defmodule UpLearn.Crawler do

  alias UpLearn.Adapter.Request
  @doc """
  Accept url and returns map with assets & links attributes
  """
  def fetch("" <> url) do
    url
    |> Request.get()
    |> process_response(:links)
  end

  defp process_response({:ok, %{body: body, status_code: 200}}, :links) do
    document = Floki.parse_document!(body)

    %{
      assets: find_attributes(document, {"img", "src"}),
      links: find_attributes(document, {"a", "href"})
    }
  end

  defp process_response({_, error}, _type), do: {:error, error}

  defp find_attributes(body, {element, attr}) do
    body
    |> Floki.find(element)
    |> Floki.attribute(attr)
  end
end
