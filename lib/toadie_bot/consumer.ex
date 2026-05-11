defmodule ToadieBot.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api.Message
  alias ToadieBot.Commands

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    content =
      msg.content
      |> to_string()
      |> String.trim()

    handle_command(content, msg.channel_id)
  end

  defp handle_command("!qualquercarta", channel_id) do
    Message.create(channel_id, Commands.cartas())
  end

  defp handle_command("!livro " <> nome, channel_id) do
    Message.create(channel_id, Commands.livro(nome))
  end

  defp handle_command("!moeda " <> moeda_args, channel_id) do
    partes =
      String.split(moeda_args, " ", parts: 2)

    origem = Enum.at(partes, 0, "")
    destino = Enum.at(partes, 1, "")

    Message.create(
      channel_id,
      Commands.moeda(origem, destino)
    )
  end

  defp handle_command("!feriadonaflorida " <> data, channel_id) do
    Message.create(channel_id, Commands.curiosidade(data))
  end

  defp handle_command("!feriado " <> data, channel_id) do
    Message.create(channel_id, Commands.feriado(data))
  end

  defp handle_command("!floridaman " <> data, channel_id) do
    Message.create(channel_id, Commands.florida(data))
  end

  defp handle_command("!frase", channel_id) do
    Message.create(channel_id, Commands.frase())
  end

  defp handle_command(_, _) do
    :ignore
  end
end