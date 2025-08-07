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

    # Convert arrays back to strings for form display
    post_for_form = convert_arrays_to_strings(post)
    changeset = Blog.change_post(post_for_form)

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
    # Preprocess array fields (tags)
    post_params = preprocess_array_fields(post_params)

    case socket.assigns.live_action do
      :new -> create_post(socket, post_params)
      :edit -> update_post(socket, post_params)
    end
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    # Preprocess array fields (tags)
    post_params = preprocess_array_fields(post_params)

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

  # Helper function for template display - safely convert tags to array
  defp safe_tags_array(nil), do: []
  defp safe_tags_array(tags) when is_list(tags), do: tags
  defp safe_tags_array(tags) when is_binary(tags), do: String.split(tags, ",") |> Enum.map(&String.trim/1)

  # Convert arrays back to comma-separated strings for form editing
  defp convert_arrays_to_strings(post) do
    Map.update(post, :tags, nil, &array_to_string/1)
  end

  # Preprocess array fields - convert comma-separated strings to arrays
  defp preprocess_array_fields(params) do
    convert_to_array(params, "tags")
  end

  # Convert a comma-separated string field to an array
  defp convert_to_array(params, field_name) do
    case Map.get(params, field_name) do
      value when is_binary(value) and value != "" ->
        # Split by comma and clean up whitespace
        array_value =
          value
          |> String.split(",")
          |> Enum.map(&String.trim/1)
          |> Enum.reject(&(&1 == ""))

        Map.put(params, field_name, array_value)

      _ ->
        params
    end
  end

  defp array_to_string(nil), do: nil
  defp array_to_string(value) when is_list(value), do: Enum.join(value, ", ")
  defp array_to_string(value), do: value
end
