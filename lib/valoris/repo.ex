defmodule Valoris.Repo do
  use Ecto.Repo,
    otp_app: :valoris,
    adapter: Ecto.Adapters.Postgres
end
