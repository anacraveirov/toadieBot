defmodule ToadieBot.Commands do
  alias ToadieBot.Http

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

  def radio(pais) do
    url =
      "https://de1.api.radio-browser.info/json/stations/bycountry/" <>
        URI.encode(pais)

    case Http.get(url) do
      {:ok, body} ->
        radio =
          body
          |> List.first()

        if radio do
          nome = radio["name"]
          idioma = radio["language"]

          "Rádio: #{nome}\nIdioma: #{idioma}"
        else
          "Nenhuma rádio encontrada :("
        end

      _ ->
        "Não foi possível encontrar uma rádio :("
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

  def museu(obra) do
    busca_url =
      "https://collectionapi.metmuseum.org/public/collection/v1/search?q=" <>
        URI.encode(obra)

    case Http.get(busca_url) do
      {:ok, body} ->
        id =
          body["objectIDs"]
          |> List.first()

        if id do
          detalhe_url =
            "https://collectionapi.metmuseum.org/public/collection/v1/objects/#{id}"

          case Http.get(detalhe_url) do
            {:ok, detalhe} ->
              titulo = detalhe["title"]
              artista = detalhe["artistDisplayName"]

              "Obra: #{titulo}\nArtista: #{artista}"

            _ ->
              "Não foi possível encontrar detalhes da obra :("
          end
        else
          "Nenhuma obra encontrada :("
        end

      _ ->
        "Não foi possível encontrar a obra :("
    end
  end

  def curiosidade(data) do
    feriado_info = feriado(data)
    florida_info = florida(data)

    "#{feriado_info}\n\n#{florida_info}"
  end
end
