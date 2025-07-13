defmodule ChimeraCmsWeb.Api.ProjectController do
  use ChimeraCmsWeb, :controller

  alias ChimeraCms.Portfolio

  def index(conn, _params) do
    projects = Portfolio.list_projects()
    render(conn, :index, projects: projects)
  end

  def show(conn, %{"id" => id}) do
    case Portfolio.get_project(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Project not found"})

      project ->
        render(conn, :show, project: project)
    end
  end
end
