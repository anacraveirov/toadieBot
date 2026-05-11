defmodule ToadieBot.Commands do
  alias ToadieBot.Http

def salvar_feriado(data, nome_feriado) do
  arquivo = "feriados.json"

  novo_feriado = %{
    data: data,
    feriado: nome_feriado
  }

  conteudo =
    case File.read(arquivo) do
      {:ok, texto} ->
        Jason.decode!(texto)

      _ ->
        []
    end

  novo_conteudo = conteudo ++ [novo_feriado]

  json =
    Jason.encode!(novo_conteudo, pretty: true)

  File.write!(arquivo, json)
end

  def livro(nome) do
    url =
      "https://openlibrary.org/search.json?q=" <>
        URI.encode(nome)

    case Http.get(url) do
      {:ok, body} ->
        livro =
          body["docs"]
          |> List.first()

        if livro do
          titulo = livro["title"] || " "
          autor =
            livro["author_name"]
            |> List.first()

          "Livro: #{titulo}\nAutor: #{autor}"
        else
          "Nenhum livro foi encontrado :("
        end

      _ ->
        "Não foi possível encontrar o livro :("
    end
  end

  def cartas do
    url = "https://deckofcardsapi.com/api/deck/new/draw/?count=1"

    case Http.get(url) do
      {:ok, body} ->
        carta =
          body["cards"]
          |> List.first()

        valor = carta["value"]
        naipe = carta["suit"]

        "Carta sorteada: #{valor} of #{naipe}"

      _ ->
        "Não foi possível sortear uma carta :("
    end
  end

def moeda(origem, destino) do
  url =
    "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/" <>
      String.downcase(origem) <>
      ".json"

  case Http.get(url) do
    {:ok, body} ->
      taxas = body[String.downcase(origem)]

      valor =
        taxas[String.downcase(destino)]

      if valor do
        "1 #{String.upcase(origem)} = #{valor} #{String.upcase(destino)}"
      else
        "Moeda não encontrada :("
      end

    _ ->
      "Não foi possível converter moedas :("
  end
end

def frase do
  url = "https://zenquotes.io/api/random"

  case Http.get(url) do
    {:ok, body} ->
      frase =
        body
        |> List.first()

      texto = frase["q"]
      autor = frase["a"]

      "\"#{texto}\"\n- #{autor}"

    _ ->
      "Não foi possível encontrar uma frase :("
  end
end

def feriado(data) do
  [dia, mes, ano] = String.split(data, "/")

  data_formatada = "#{ano}-#{mes}-#{dia}"

  url =
    "https://date.nager.at/api/v3/PublicHolidays/#{ano}/BR"

  case Http.get(url) do
    {:ok, body} ->
      feriado =
        Enum.find(body, fn item ->
          item["date"] == data_formatada
        end)

      if feriado do
        nome = feriado["localName"]

        salvar_feriado(data, nome)

        "Esse foi o feriado encontrado: #{nome}!"
      else
        "Não foi encontrado nenhum feriado nessa data :("
      end

    _ ->
      "Não foi possível encontrar um feriado :("
  end
end

def florida(data) do
  [dia, mes, _ano] = String.split(data, "/")

  url =
    "https://juliayxhuang.github.io/florida-man-api/api/#{mes}/#{dia}.json"

  case Http.get(url) do
    {:ok, body} when is_list(body) ->
      noticia =
        body
        |> List.first()

      if noticia do
        titulo = noticia["title"]
        fonte = noticia["source"]

        "Nesse dia na história, um homem na Florida fez isso:\n#{titulo}\nFonte: #{fonte}"
      else
        "Nenhuma notícia encontrada para essa data :("
      end

    _ ->
      "Não foi possível encontrar um artigo sobre um Florida Man :("
  end
end

  def curiosidade(data) do
    feriado_info = feriado(data)
    florida_info = florida(data)

    "#{feriado_info}\n\n#{florida_info}"
  end
end