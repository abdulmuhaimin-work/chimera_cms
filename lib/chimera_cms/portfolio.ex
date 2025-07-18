defmodule ChimeraCms.Portfolio do
  @moduledoc """
  The Portfolio context.
  """

  import Ecto.Query, warn: false
  alias ChimeraCms.Repo
  alias ChimeraCms.Portfolio.Project

  @pubsub_topic "portfolio_projects"

  def subscribe do
    Phoenix.PubSub.subscribe(ChimeraCms.PubSub, @pubsub_topic)
  end

  defp broadcast({:ok, project}, event) do
    Phoenix.PubSub.broadcast(ChimeraCms.PubSub, @pubsub_topic, {event, project})
    {:ok, project}
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  @doc """
  Returns the list of projects ordered by sort_order.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    from(p in Project, order_by: [asc: p.sort_order, desc: p.inserted_at])
    |> Repo.all()
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Repo.get!(Project, id)

  @doc """
  Gets a single project.

  Returns nil if the Project does not exist.

  ## Examples

      iex> get_project(123)
      %Project{}

      iex> get_project(456)
      nil

  """
  def get_project(id), do: Repo.get(Project, id)

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:project_created)
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
    |> broadcast(:project_updated)
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    result = Repo.delete(project)
    case result do
      {:ok, deleted_project} ->
        Phoenix.PubSub.broadcast(ChimeraCms.PubSub, @pubsub_topic, {:project_deleted, deleted_project})
        {:ok, deleted_project}
      error -> error
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end
end
