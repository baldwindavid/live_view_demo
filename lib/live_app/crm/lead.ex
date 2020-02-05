defmodule LiveApp.CRM.Lead do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leads" do
    field :name, :string
    field :urgency, :string
    field :phone, :string
    timestamps()
  end

  @phone ~r/^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$/
  @urgencies ~w(low medium high)

  def urgencies, do: @urgencies

  def changeset(lead, attrs) do
    lead
    |> cast(attrs, [:name, :urgency, :phone])
    |> validate_required([:name])
    |> validate_format(:phone, @phone, message: "must be a valid number")
    |> validate_inclusion(:urgency, @urgencies)
  end
end
