defmodule ChimeraCmsWeb.Admin.ProjectController do
  use ChimeraCmsWeb, :controller

  alias ChimeraCms.Portfolio
  alias ChimeraCms.Portfolio.Project

  def index(conn, _params) do
    projects = Portfolio.list_projects()
    render(conn, :index, projects: projects)
  end

  def show(conn, %{"id" => id}) do
    project = Portfolio.get_project!(id)
    render(conn, :show, project: project)
  end

  def create(conn, %{"project" => project_params}) do
    case Portfolio.create_project(project_params) do
      {:ok, project} ->
        conn
        |> put_status(:created)
        |> render(:show, project: project)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_changeset_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Portfolio.get_project!(id)

    case Portfolio.update_project(project, project_params) do
      {:ok, project} ->
        render(conn, :show, project: project)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_changeset_errors(changeset)})
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Portfolio.get_project!(id)

    with {:ok, %Project{}} <- Portfolio.delete_project(project) do
      send_resp(conn, :no_content, "")
    end
  end

  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
