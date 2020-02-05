defmodule LiveAppWeb.Lead.IndexLive do
  use Phoenix.LiveView
  alias LiveApp.CRM
  alias LiveAppWeb.LeadView

  ################################
  # Setup
  ################################
  def render(assigns) do
    LeadView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    CRM.subscribe()
    leads = CRM.list_leads()
    urgencies = CRM.list_lead_urgencies()

    {:ok,
     assign(socket,
       leads: leads,
       current_lead_id: nil,
       changeset: nil,
       urgencies: urgencies,
       urgency_filter: nil
     )}
  end



  ################################
  # Form Validation
  ################################
  def handle_event("save", %{"lead" => lead_params}, socket) do
    lead = CRM.get_lead!(lead_params["id"])

    case CRM.update_lead(lead, lead_params) do
      {:ok, _lead} ->
        {:noreply, assign(socket, current_lead_id: nil, changeset: nil)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("validate", %{"lead" => lead_params}, socket) do
    changeset =
      CRM.get_lead!(lead_params["id"])
      |> CRM.change_lead(lead_params)
      |> Map.put(:action, :update)

    {:noreply, assign(socket, changeset: changeset)}
  end



  ################################
  # Click Events With Values
  ################################
  def handle_event("edit", %{"id" => id}, socket) do
    lead = CRM.get_lead!(id)
    changeset = CRM.change_lead(lead)

    {:noreply, assign(socket, current_lead_id: lead.id, changeset: changeset)}
  end

  def handle_event("cancel", %{"id" => id}, socket) do
    {:noreply, assign(socket, current_lead_id: nil, changeset: nil)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    lead = CRM.get_lead!(id)
    {:ok, _lead} = CRM.delete_lead(lead)

    {:noreply, socket}
  end



  ################################
  # Filtering / Live Links
  ################################
  def handle_params(%{"urgency" => urgency}, _uri, socket) when urgency in ~w(low medium high) do
    leads = CRM.list_leads(urgency)
    {:noreply, assign(socket, leads: leads, urgency_filter: urgency)}
  end

  def handle_params(%{"urgency" => "all"}, _uri, socket) do
    leads = CRM.list_leads()
    {:noreply, assign(socket, leads: leads, urgency_filter: nil)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end



  ################################
  # Real-Time Updates
  ################################
  def handle_info({CRM, [:lead | _], _}, socket) do
    leads = CRM.list_leads(socket.assigns.urgency_filter)
    {:noreply, assign(socket, leads: leads)}
  end
end
