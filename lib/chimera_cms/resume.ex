defmodule ChimeraCms.Resume do
  @moduledoc """
  The Resume context.
  """

  alias ChimeraCms.EtsRepo, as: Repo

  alias ChimeraCms.Resume.WorkExperience

  @pubsub_topic "resume_work_experiences"

  def subscribe do
    Phoenix.PubSub.subscribe(ChimeraCms.PubSub, @pubsub_topic)
  end

  defp broadcast({:ok, work_experience}, event) do
    Phoenix.PubSub.broadcast(ChimeraCms.PubSub, @pubsub_topic, {event, work_experience})
    {:ok, work_experience}
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  @doc """
  Returns the list of work_experiences ordered by sort_order.

  ## Examples

      iex> list_work_experiences()
      [%WorkExperience{}, ...]

  """
  def list_work_experiences do
    Repo.all(WorkExperience)
    |> Enum.sort_by(fn w -> {w.sort_order || 0, w.inserted_at} end, fn {a_sort, a_time}, {b_sort, b_time} ->
      cond do
        a_sort != b_sort -> a_sort <= b_sort
        true -> DateTime.compare(a_time, b_time) == :gt
      end
    end)
  end

  @doc """
  Gets a single work_experience.

  Raises `Ecto.NoResultsError` if the Work experience does not exist.

  ## Examples

      iex> get_work_experience!(123)
      %WorkExperience{}

      iex> get_work_experience!(456)
      ** (Ecto.NoResultsError)

  """
  def get_work_experience!(id), do: Repo.get!(WorkExperience, id)

  @doc """
  Gets a single work_experience.

  Returns nil if the Work experience does not exist.

  ## Examples

      iex> get_work_experience(123)
      %WorkExperience{}

      iex> get_work_experience(456)
      nil

  """
  def get_work_experience(id), do: Repo.get(WorkExperience, id)

  @doc """
  Creates a work_experience.

  ## Examples

      iex> create_work_experience(%{field: value})
      {:ok, %WorkExperience{}}

      iex> create_work_experience(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_work_experience(attrs \\ %{}) do
    %WorkExperience{}
    |> WorkExperience.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:work_experience_created)
  end

  @doc """
  Updates a work_experience.

  ## Examples

      iex> update_work_experience(work_experience, %{field: new_value})
      {:ok, %WorkExperience{}}

      iex> update_work_experience(work_experience, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_work_experience(%WorkExperience{} = work_experience, attrs) do
    work_experience
    |> WorkExperience.changeset(attrs)
    |> Repo.update()
    |> broadcast(:work_experience_updated)
  end

  @doc """
  Deletes a work_experience.

  ## Examples

      iex> delete_work_experience(work_experience)
      {:ok, %WorkExperience{}}

      iex> delete_work_experience(work_experience)
      {:error, %Ecto.Changeset{}}

  """
  def delete_work_experience(%WorkExperience{} = work_experience) do
    Repo.delete(work_experience)
    |> broadcast(:work_experience_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking work_experience changes.

  ## Examples

      iex> change_work_experience(work_experience)
      %Ecto.Changeset{data: %WorkExperience{}}

  """
  def change_work_experience(%WorkExperience{} = work_experience, attrs \\ %{}) do
    WorkExperience.changeset(work_experience, attrs)
  end
end
