defmodule ChimeraCms.Blog do
  @moduledoc """
  The Blog context.
  """

  alias ChimeraCms.EtsRepo, as: Repo
  alias ChimeraCms.Blog.Post

  @pubsub_topic "blog_posts"

  def subscribe do
    Phoenix.PubSub.subscribe(ChimeraCms.PubSub, @pubsub_topic)
  end

  defp broadcast({:ok, post}, event) do
    Phoenix.PubSub.broadcast(ChimeraCms.PubSub, @pubsub_topic, {event, post})
    {:ok, post}
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:blog_post_created)
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
    |> broadcast(:blog_post_updated)
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    result = Repo.delete(post)
    case result do
      {:ok, deleted_post} ->
        Phoenix.PubSub.broadcast(ChimeraCms.PubSub, @pubsub_topic, {:blog_post_deleted, deleted_post})
        {:ok, deleted_post}
      error -> error
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  @doc """
  Returns the list of published posts.
  """
  def list_published_posts do
    Repo.all(Post)
    |> Enum.filter(& &1.published)
    |> Enum.sort_by(& &1.published_at, {:desc, DateTime})
  end

  @doc """
  Gets a single post by slug.
  """
  def get_post_by_slug(slug) do
    Repo.get_by(Post, :slug, slug)
  end
end
