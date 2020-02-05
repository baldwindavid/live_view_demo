defmodule LiveApp.CRM do
  import Ecto.Query, warn: false
  alias LiveApp.Repo
  alias LiveApp.CRM.Lead

  @topic inspect(__MODULE__)

  def list_lead_urgencies do
    Lead.urgencies()
  end

  def list_leads(urgency \\ nil) do
    from(Lead, order_by: :inserted_at)
    |> maybe_filter_by_urgency(urgency)
    |> Repo.all()
  end

  defp maybe_filter_by_urgency(query, nil), do: query

  defp maybe_filter_by_urgency(query, urgency) do
    from(l in query, where: l.urgency == ^urgency)
  end

  def get_lead!(id) do
    Repo.get!(Lead, id)
  end

  def new_lead do
    %Lead{}
  end

  def create_lead(attrs) do
    %Lead{}
    |> Lead.changeset(attrs)
    |> Repo.insert()
    |> broadcast([:lead, :created])
  end

  def change_lead(%Lead{} = lead, attrs \\ %{}) do
    lead
    |> Lead.changeset(attrs)
  end

  def update_lead(%Lead{} = lead, attrs) do
    lead
    |> Lead.changeset(attrs)
    |> Repo.update()
    |> broadcast([:lead, :updated])
  end

  def delete_lead(%Lead{} = lead) do
    lead
    |> Repo.delete()
    |> broadcast([:lead, :deleted])
  end

  def subscribe do
    Phoenix.PubSub.subscribe(LiveApp.PubSub, @topic)
  end

  defp broadcast({:ok, result}, event) do
    Phoenix.PubSub.broadcast(LiveApp.PubSub, @topic, {__MODULE__, event, result})
    {:ok, result}
  end

  defp broadcast({:error, reason}, _event), do: {:error, reason}
end
