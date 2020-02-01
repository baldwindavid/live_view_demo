defmodule LiveApp.Repo do
  use Ecto.Repo,
    otp_app: :live_app,
    adapter: Ecto.Adapters.Postgres
end
