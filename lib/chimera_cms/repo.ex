defmodule ChimeraCms.Repo do
  use Ecto.Repo,
    otp_app: :chimera_cms,
    adapter: Ecto.Adapters.Postgres
end
