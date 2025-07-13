defmodule ChimeraCmsWeb.Admin.ProjectsLive do
  use ChimeraCmsWeb, :live_view

  alias ChimeraCms.Portfolio
  alias ChimeraCms.Portfolio.Project

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Portfolio.subscribe()
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Projects")
    |> assign(:projects, Portfolio.list_projects())
    |> assign(:project, nil)
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    project = Portfolio.get_project!(id)

    socket
    |> assign(:page_title, project.title)
    |> assign(:project, project)
  end

  defp apply_action(socket, :new, _params) do
    changeset = Portfolio.change_project(%Project{})

    socket
    |> assign(:page_title, "New Project")
    |> assign(:project, %Project{})
    |> assign(:changeset, changeset)
    |> assign(:form, to_form(changeset))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    project = Portfolio.get_project!(id)
    changeset = Portfolio.change_project(project)

    socket
    |> assign(:page_title, "Edit Project")
    |> assign(:project, project)
    |> assign(:changeset, changeset)
    |> assign(:form, to_form(changeset))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    project = Portfolio.get_project!(id)
    {:ok, _} = Portfolio.delete_project(project)

    {:noreply, assign(socket, :projects, Portfolio.list_projects())}
  end

  @impl true
  def handle_event("toggle_featured", %{"id" => id}, socket) do
    project = Portfolio.get_project!(id)
    {:ok, _} = Portfolio.update_project(project, %{featured: !project.featured})

    {:noreply, assign(socket, :projects, Portfolio.list_projects())}
  end

  @impl true
  def handle_event("save", %{"project" => project_params}, socket) do
    case socket.assigns.live_action do
      :new -> create_project(socket, project_params)
      :edit -> update_project(socket, project_params)
    end
  end

  @impl true
  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset =
      socket.assigns.project
      |> Portfolio.change_project(project_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:form, to_form(changeset))}
  end

  defp create_project(socket, project_params) do
    case Portfolio.create_project(project_params) do
      {:ok, project} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project created successfully")
         |> push_navigate(to: ~p"/admin/projects/#{project.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> assign(:form, to_form(changeset))}
    end
  end

  defp update_project(socket, project_params) do
    case Portfolio.update_project(socket.assigns.project, project_params) do
      {:ok, project} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project updated successfully")
         |> push_navigate(to: ~p"/admin/projects/#{project.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> assign(:form, to_form(changeset))}
    end
  end

  @impl true
  def handle_info({:project_created, project}, socket) do
    {:noreply, update(socket, :projects, fn projects -> [project | projects] end)}
  end

  @impl true
  def handle_info({:project_updated, project}, socket) do
    {:noreply, update(socket, :projects, fn projects ->
      Enum.map(projects, fn p -> if p.id == project.id, do: project, else: p end)
    end)}
  end

  @impl true
  def handle_info({:project_deleted, project}, socket) do
    {:noreply, update(socket, :projects, fn projects ->
      Enum.reject(projects, fn p -> p.id == project.id end)
    end)}
  end
end
