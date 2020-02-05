defmodule LiveAppWeb.Lead.NewLive do
  use Phoenix.LiveView
  alias LiveApp.CRM
  alias LiveAppWeb.LeadView

  ################################
  # Setup
  ################################
  def render(assigns) do
    LeadView.render("new.html", assigns)
  end

  def mount(_params, _session, socket) do
    changeset = CRM.new_lead() |> CRM.change_lead()

    {:ok, assign(socket, changeset: changeset, lead_submitted: false)}
  end



  ################################
  # Form Validation
  ################################
  def handle_event("save", %{"lead" => lead_params}, socket) do
    case CRM.create_lead(lead_params) do
      {:ok, _lead} ->
        changeset = CRM.new_lead() |> CRM.change_lead()

        {:noreply, assign(socket, changeset: changeset, lead_submitted: true)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("validate", %{"lead" => lead_params}, socket) do
    changeset =
      CRM.new_lead()
      |> CRM.change_lead(lead_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end



  ################################
  # Click Events
  ################################
  def handle_event("reset", _, socket) do
    {:noreply, assign(socket, lead_submitted: false)}
  end
end
