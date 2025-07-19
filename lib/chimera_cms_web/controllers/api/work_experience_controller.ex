defmodule ChimeraCmsWeb.Api.WorkExperienceController do
  use ChimeraCmsWeb, :controller

  alias ChimeraCms.Resume

  def index(conn, _params) do
    work_experiences = Resume.list_work_experiences()
    render(conn, :index, work_experiences: work_experiences)
  end

  def show(conn, %{"id" => id}) do
    case Resume.get_work_experience(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Work experience not found"})

      work_experience ->
        render(conn, :show, work_experience: work_experience)
    end
  end
end
