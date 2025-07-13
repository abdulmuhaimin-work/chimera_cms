defmodule ChimeraCmsWeb.Admin.PostJSON do
  @doc """
  Renders a list of posts.
  """
  def index(%{posts: posts}) do
    %{data: for(post <- posts, do: data(post))}
  end

  @doc """
  Renders a single post.
  """
  def show(%{post: post}) do
    %{data: data(post)}
  end

  defp data(%ChimeraCms.Blog.Post{} = post) do
    %{
      id: post.id,
      title: post.title,
      slug: post.slug,
      content: post.content,
      excerpt: post.excerpt,
      featured_image: post.featured_image,
      published: post.published,
      published_at: post.published_at,
      tags: post.tags,
      inserted_at: post.inserted_at,
      updated_at: post.updated_at
    }
  end
end
