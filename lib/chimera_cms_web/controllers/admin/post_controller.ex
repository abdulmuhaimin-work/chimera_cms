defmodule ChimeraCmsWeb.Admin.PostController do
  use ChimeraCmsWeb, :controller

  alias ChimeraCms.Blog
  alias ChimeraCms.Blog.Post

  def index(conn, _params) do
    posts = Blog.list_posts()
    render(conn, :index, posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    render(conn, :show, post: post)
  end

  def create(conn, %{"post" => post_params}) do
    case Blog.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_status(:created)
        |> render(:show, post: post)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_changeset_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Blog.get_post!(id)

    case Blog.update_post(post, post_params) do
      {:ok, post} ->
        render(conn, :show, post: post)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_changeset_errors(changeset)})
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Blog.get_post!(id)

    with {:ok, %Post{}} <- Blog.delete_post(post) do
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
