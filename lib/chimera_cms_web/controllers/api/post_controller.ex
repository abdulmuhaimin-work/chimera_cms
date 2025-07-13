defmodule ChimeraCmsWeb.Api.PostController do
  use ChimeraCmsWeb, :controller

  alias ChimeraCms.Blog

  def index(conn, _params) do
    posts = Blog.list_published_posts()
    render(conn, :index, posts: posts)
  end

  def show(conn, %{"slug" => slug}) do
    case Blog.get_post_by_slug(slug) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Post not found"})

      post ->
        render(conn, :show, post: post)
    end
  end
end
