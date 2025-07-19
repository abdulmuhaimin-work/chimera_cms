defmodule ChimeraCmsWeb.Admin.WorkExperienceController do
  use ChimeraCmsWeb, :controller

  alias ChimeraCms.Resume
  alias ChimeraCms.Resume.WorkExperience

  def index(conn, _params) do
    work_experiences = Resume.list_work_experiences()
    render(conn, :index, work_experiences: work_experiences)
  end

  def show(conn, %{"id" => id}) do
    work_experience = Resume.get_work_experience!(id)
    render(conn, :show, work_experience: work_experience)
  end

  def new(conn, _params) do
    changeset = Resume.change_work_experience(%WorkExperience{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"work_experience" => work_experience_params}) do
    case Resume.create_work_experience(work_experience_params) do
      {:ok, work_experience} ->
        conn
        |> put_flash(:info, "Work experience created successfully.")
        |> redirect(to: ~p"/admin/work-experiences/#{work_experience}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    work_experience = Resume.get_work_experience!(id)
    changeset = Resume.change_work_experience(work_experience)
    render(conn, :edit, work_experience: work_experience, changeset: changeset)
  end

  def update(conn, %{"id" => id, "work_experience" => work_experience_params}) do
    work_experience = Resume.get_work_experience!(id)

    case Resume.update_work_experience(work_experience, work_experience_params) do
      {:ok, work_experience} ->
        conn
        |> put_flash(:info, "Work experience updated successfully.")
        |> redirect(to: ~p"/admin/work-experiences/#{work_experience}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, work_experience: work_experience, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    work_experience = Resume.get_work_experience!(id)
    {:ok, _work_experience} = Resume.delete_work_experience(work_experience)

    conn
    |> put_flash(:info, "Work experience deleted successfully.")
    |> redirect(to: ~p"/admin/work-experiences")
  end
end
