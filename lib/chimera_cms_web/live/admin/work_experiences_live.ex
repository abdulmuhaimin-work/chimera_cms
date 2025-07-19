defmodule ChimeraCmsWeb.Admin.WorkExperiencesLive do
  use ChimeraCmsWeb, :live_view

  alias ChimeraCms.Resume
  alias ChimeraCms.Resume.WorkExperience

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Resume.subscribe()
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Work Experiences")
    |> assign(:work_experiences, Resume.list_work_experiences())
    |> assign(:work_experience, nil)
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    work_experience = Resume.get_work_experience!(id)

    socket
    |> assign(:page_title, work_experience.title)
    |> assign(:work_experience, work_experience)
  end

  defp apply_action(socket, :new, _params) do
    changeset = Resume.change_work_experience(%WorkExperience{})

    socket
    |> assign(:page_title, "New Work Experience")
    |> assign(:work_experience, %WorkExperience{})
    |> assign(:changeset, changeset)
    |> assign(:form, to_form(changeset))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    work_experience = Resume.get_work_experience!(id)
    # Convert technologies array back to string for form display
    work_experience_with_string_techs = %{work_experience | technologies: technologies_to_string(work_experience.technologies)}
    changeset = Resume.change_work_experience(work_experience_with_string_techs)

    socket
    |> assign(:page_title, "Edit Work Experience")
    |> assign(:work_experience, work_experience_with_string_techs)
    |> assign(:changeset, changeset)
    |> assign(:form, to_form(changeset))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    work_experience = Resume.get_work_experience!(id)

    case Resume.delete_work_experience(work_experience) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Work experience deleted successfully")
         |> assign(:work_experiences, Resume.list_work_experiences())}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to delete work experience")}
    end
  end

  @impl true
  def handle_event("save", %{"work_experience" => work_experience_params}, socket) do
    case socket.assigns.live_action do
      :new -> create_work_experience(socket, work_experience_params)
      :edit -> update_work_experience(socket, work_experience_params)
    end
  end

  @impl true
  def handle_event("validate", %{"work_experience" => work_experience_params}, socket) do
    processed_params = process_technologies(work_experience_params)

    changeset =
      socket.assigns.work_experience
      |> Resume.change_work_experience(processed_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:form, to_form(changeset))}
  end

  defp create_work_experience(socket, work_experience_params) do
    processed_params = process_technologies(work_experience_params)

    case Resume.create_work_experience(processed_params) do
      {:ok, work_experience} ->
        {:noreply,
         socket
         |> put_flash(:info, "Work experience created successfully")
         |> push_navigate(to: ~p"/admin/work-experiences/#{work_experience.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> assign(:form, to_form(changeset))}
    end
  end

  defp update_work_experience(socket, work_experience_params) do
    processed_params = process_technologies(work_experience_params)
    # Get the original work experience (not the one with string technologies)
    original_work_experience = Resume.get_work_experience!(socket.assigns.work_experience.id)

    case Resume.update_work_experience(original_work_experience, processed_params) do
      {:ok, work_experience} ->
        {:noreply,
         socket
         |> put_flash(:info, "Work experience updated successfully")
         |> push_navigate(to: ~p"/admin/work-experiences/#{work_experience.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> assign(:form, to_form(changeset))}
    end
  end

  @impl true
  def handle_info({:work_experience_created, work_experience}, socket) do
    {:noreply, update(socket, :work_experiences, fn work_experiences -> [work_experience | work_experiences] end)}
  end

  @impl true
  def handle_info({:work_experience_updated, work_experience}, socket) do
    {:noreply, update(socket, :work_experiences, fn work_experiences ->
      Enum.map(work_experiences, fn we -> if we.id == work_experience.id, do: work_experience, else: we end)
    end)}
  end

  @impl true
  def handle_info({:work_experience_deleted, work_experience}, socket) do
    {:noreply, update(socket, :work_experiences, fn work_experiences ->
      Enum.reject(work_experiences, fn we -> we.id == work_experience.id end)
    end)}
  end

  # Helper functions for technologies field conversion
  defp process_technologies(%{"technologies" => technologies} = params) when is_binary(technologies) do
    technology_list =
      technologies
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.filter(&(&1 != ""))

    Map.put(params, "technologies", technology_list)
  end

  defp process_technologies(params), do: params

  defp technologies_to_string(technologies) when is_list(technologies) do
    Enum.join(technologies, "\n")
  end

  defp technologies_to_string(_), do: ""
end
