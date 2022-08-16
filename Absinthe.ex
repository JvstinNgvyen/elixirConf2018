defmodule ScoreboardWeb.Schema do
  # Web context
  use Absinthe.Schema
  alias Scoreboard.Games

  # Object or nodes
  @desc "A Game"
  object :game do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:scores, list_of(:score), resolve: scores/2)

  object :score do
    field(:id, non_null(:id))
    field(:total, non_null(:integer))

    field(:player, :player, resolve:
      fn %{player_id: id}, _, _ ->
        Games.get_player(id)
      end)
  end
  end

  # Query block
  query do
    # Root query
    field :game, :game do
      arg(:id, non_null(:id))
      # Resolver
      resolve(fn  %{id: game_id}, _ ->
        Games.get_game(game_id)
      end)
    end
  end
end

# Only find scores associated with our current Game
def game_scores(%Game{id: game_id}, _args, _res) do
  {:ok,
  Score
    |> where([score], score.game_id == ^game_id)
    |> Repo.all()
  }
end


QuoteRequest |> where([qr], qr.created_by_id > ^Date.utc_today()) |> limit(10)
future_quote = v()
future_quote |> select([qr], qr.coverage_effective_at) |> Repo.all()
