defmodule ChimeraCmsWeb.Admin.ProjectsLive do
  use ChimeraCmsWeb, :live_view

  alias ChimeraCms.Portfolio
  alias ChimeraCms.Portfolio.Project

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Portfolio.subscribe()
    end

    {:ok, socket
    |> allow_upload(:image, accept: ~w(.jpg .jpeg .png .gif .webp), max_entries: 1, max_file_size: 5_000_000)}
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

    case Portfolio.delete_project(project) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project deleted successfully")
         |> assign(:projects, Portfolio.list_projects())}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to delete project")}
    end
  end

  @impl true
  def handle_event("toggle_featured", %{"id" => id}, socket) do
    project = Portfolio.get_project!(id)

    case Portfolio.update_project(project, %{featured: !project.featured}) do
      {:ok, _} ->
        action = if project.featured, do: "unfeatured", else: "featured"
        {:noreply,
         socket
         |> put_flash(:info, "Project #{action} successfully")
         |> assign(:projects, Portfolio.list_projects())}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to update project")}
    end
  end

  @impl true
  def handle_event("save", %{"project" => project_params}, socket) do
    # Handle file upload if present
    project_params = handle_file_upload(socket, project_params)

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

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
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

    # Handle file upload
  defp handle_file_upload(socket, project_params) do
    case uploaded_entries(socket, :image) do
      [] ->
        project_params

      [entry] ->
        case consume_uploaded_entry(socket, entry, fn %{path: path} ->
          # Generate unique filename
          extension = Path.extname(entry.client_name)
          filename = "#{System.unique_integer()}_#{System.os_time()}" <> extension

          # Create uploads directory if it doesn't exist
          uploads_dir = Path.join([Application.app_dir(:chimera_cms, "priv"), "static", "uploads"])
          File.mkdir_p!(uploads_dir)

          # Copy file to uploads directory
          dest_path = Path.join(uploads_dir, filename)
          File.cp!(path, dest_path)

          # Return the URL path
          {:ok, "/uploads/#{filename}"}
        end) do
          {:ok, image_url} ->
            Map.put(project_params, "image", image_url)

          {:error, _reason} ->
            project_params
        end
    end
  end

  # Helper function to humanize upload errors
  defp humanize_upload_error(:too_large), do: "File is too large (max 5MB)"
  defp humanize_upload_error(:too_many_files), do: "You can only upload one file"
  defp humanize_upload_error(:not_accepted), do: "File type not supported. Please use PNG, JPG, GIF, or WebP"
  defp humanize_upload_error(error), do: "Upload error: #{error}"
end
