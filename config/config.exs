import Config

part1 = "MTUwMjc3MzMzODI1NzM1ODk1OA.Gh8Etd."
part2 = "4VzZ4lO6JRmpghMddNQhYy4Z3HcNJUdO3"
part3 = "-5twg"

config :nostrum,
token: part1 <> part2 <> part3,
  gateway_intents: [
    :guild_messages,
    :message_content
  ]