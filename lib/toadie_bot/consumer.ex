defmodule ToadieBot.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias ToadieBot.Commands

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    content = String.trim(msg.content)

    cond do
      String.starts_with?(content, "!livro") ->
        nome = get_args(content)
        Api.create_message(msg.channel_id, Commands.livro(nome))

      String.starts_with?(content, "!qualquercarta") ->
        Api.create_message(msg.channel_id, Commands.cartas())

      String.starts_with?(content, "!radio") ->
        pais = get_args(content)
        Api.create_message(msg.channel_id, Commands.radio(pais))

      String.starts_with?(content, "!feriadonaflorida") ->
        data = get_args(content)
        Api.create_message(msg.channel_id, Commands.curiosidade(data))

      String.starts_with?(content, "!feriado") ->
        data = get_args(content)
        Api.create_message(msg.channel_id, Commands.feriado(data))

      String.starts_with?(content, "!floridaman") ->
        data = get_args(content)
        Api.create_message(msg.channel_id, Commands.florida(data))

      String.starts_with?(content, "!museu") ->
        obra = get_args(content)
        Api.create_message(msg.channel_id, Commands.museu(obra))

      true ->
        :ignore
    end
  end

  defp get_args(content) do
    content
    |> String.split(" ", parts: 2)
    |> Enum.at(1, "")
  end
end
