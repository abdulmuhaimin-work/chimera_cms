defmodule ChimeraCmsWeb.Plugs.PublicCache do
  @moduledoc """
  Sets HTTP caching headers for public, anonymous JSON responses so browsers
  and shared caches (e.g. Cloudflare) can serve them without hitting origin.

  Tune `max_age` (browser) and `s_maxage` (CDN) per how stale reads are acceptable
  after CMS edits.
  """
  import Plug.Conn

  def init(opts) do
    max_age = Keyword.fetch!(opts, :max_age)
    s_maxage = Keyword.get(opts, :s_maxage, max_age)
    swr = Keyword.get(opts, :stale_while_revalidate)

    directives =
      [
        "public",
        "max-age=#{max_age}",
        "s-maxage=#{s_maxage}"
      ]
      |> maybe_add_swr(swr)

    %{value: Enum.join(directives, ", ")}
  end

  defp maybe_add_swr(dirs, nil), do: dirs
  defp maybe_add_swr(dirs, seconds) when is_integer(seconds) and seconds > 0 do
    dirs ++ ["stale-while-revalidate=#{seconds}"]
  end

  def call(conn, %{value: value}) do
    conn
    |> put_resp_header("cache-control", value)
    |> put_resp_header("vary", "accept-encoding")
  end
end
