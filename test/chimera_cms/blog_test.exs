defmodule ChimeraCms.BlogTest do
  use ChimeraCms.DataCase

  alias ChimeraCms.Blog

  describe "posts" do
    alias ChimeraCms.Blog.Post

    import ChimeraCms.BlogFixtures

    @invalid_attrs %{title: nil, slug: nil, content: nil, excerpt: nil, featured_image: nil, published: nil, published_at: nil, tags: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Blog.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Blog.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{title: "some title", slug: "some slug", content: "some content", excerpt: "some excerpt", featured_image: "some featured_image", published: true, published_at: ~U[2025-07-12 06:51:00Z], tags: ["option1", "option2"]}

      assert {:ok, %Post{} = post} = Blog.create_post(valid_attrs)
      assert post.title == "some title"
      assert post.slug == "some slug"
      assert post.content == "some content"
      assert post.excerpt == "some excerpt"
      assert post.featured_image == "some featured_image"
      assert post.published == true
      assert post.published_at == ~U[2025-07-12 06:51:00Z]
      assert post.tags == ["option1", "option2"]
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{title: "some updated title", slug: "some updated slug", content: "some updated content", excerpt: "some updated excerpt", featured_image: "some updated featured_image", published: false, published_at: ~U[2025-07-13 06:51:00Z], tags: ["option1"]}

      assert {:ok, %Post{} = post} = Blog.update_post(post, update_attrs)
      assert post.title == "some updated title"
      assert post.slug == "some updated slug"
      assert post.content == "some updated content"
      assert post.excerpt == "some updated excerpt"
      assert post.featured_image == "some updated featured_image"
      assert post.published == false
      assert post.published_at == ~U[2025-07-13 06:51:00Z]
      assert post.tags == ["option1"]
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert post == Blog.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Blog.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end
end
