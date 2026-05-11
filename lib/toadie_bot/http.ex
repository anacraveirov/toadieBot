defmodule ToadieBot.Http do
  def get(url) do
    case HTTPoison.get(url) do
      {:ok, response} ->
        Jason.decode(response.body)

      {:error, reason} ->
        {:error, reason}
    end
  end
end