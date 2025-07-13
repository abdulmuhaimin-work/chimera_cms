defmodule ChimeraCms.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ChimeraCms.Blog` context.
  """

  @doc """
  Generate a unique post slug.
  """
  def unique_post_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        content: "some content",
        excerpt: "some excerpt",
        featured_image: "some featured_image",
        published: true,
        published_at: ~U[2025-07-12 06:51:00Z],
        slug: unique_post_slug(),
        tags: ["option1", "option2"],
        title: "some title"
      })
      |> ChimeraCms.Blog.create_post()

    post
  end
end
