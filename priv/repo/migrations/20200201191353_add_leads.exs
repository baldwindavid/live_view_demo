defmodule LiveApp.Repo.Migrations.AddLeads do
  use Ecto.Migration

  def change do
    create table(:leads) do
      add :name, :string, null: false
      add :urgency, :string
      add :phone, :string
      timestamps()
    end
  end
end
