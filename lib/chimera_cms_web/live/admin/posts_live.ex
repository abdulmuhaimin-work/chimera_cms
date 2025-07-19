defmodule ChimeraCmsWeb.Admin.PostsLive do
  use ChimeraCmsWeb, :live_view

  alias ChimeraCms.Blog
  alias ChimeraCms.Blog.Post

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Blog.subscribe()
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Posts")
    |> assign(:posts, Blog.list_posts())
    |> assign(:post, nil)
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    post = Blog.get_post!(id)

    socket
    |> assign(:page_title, post.title)
    |> assign(:post, post)
  end

  defp apply_action(socket, :new, _params) do
    changeset = Blog.change_post(%Post{})

    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
    |> assign(:changeset, changeset)
    |> assign(:form, to_form(changeset))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    post = Blog.get_post!(id)
    changeset = Blog.change_post(post)

    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, post)
    |> assign(:changeset, changeset)
    |> assign(:form, to_form(changeset))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Blog.get_post!(id)

    case Blog.delete_post(post) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post deleted successfully")
         |> assign(:posts, Blog.list_posts())}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to delete post")}
    end
  end

  @impl true
  def handle_event("toggle_published", %{"id" => id}, socket) do
    post = Blog.get_post!(id)

    case Blog.update_post(post, %{published: !post.published}) do
      {:ok, _} ->
        action = if post.published, do: "unpublished", else: "published"
        {:noreply,
         socket
         |> put_flash(:info, "Post #{action} successfully")
         |> assign(:posts, Blog.list_posts())}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to update post")}
    end
  end

  @impl true
  def handle_event("save", %{"post" => post_params}, socket) do
    case socket.assigns.live_action do
      :new -> create_post(socket, post_params)
      :edit -> update_post(socket, post_params)
    end
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Blog.change_post(post_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:form, to_form(changeset))}
  end

  defp create_post(socket, post_params) do
    case Blog.create_post(post_params) do
      {:ok, post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_navigate(to: ~p"/admin/posts/#{post.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> assign(:form, to_form(changeset))}
    end
  end

  defp update_post(socket, post_params) do
    case Blog.update_post(socket.assigns.post, post_params) do
      {:ok, post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_navigate(to: ~p"/admin/posts/#{post.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> assign(:form, to_form(changeset))}
    end
  end

  @impl true
  def handle_info({:blog_post_created, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end

  @impl true
  def handle_info({:blog_post_updated, post}, socket) do
    {:noreply, update(socket, :posts, fn posts ->
      Enum.map(posts, fn p -> if p.id == post.id, do: post, else: p end)
    end)}
  end

  @impl true
  def handle_info({:blog_post_deleted, post}, socket) do
    {:noreply, update(socket, :posts, fn posts ->
      Enum.reject(posts, fn p -> p.id == post.id end)
    end)}
  end
end
