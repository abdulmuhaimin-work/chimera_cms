defmodule ChimeraCmsWeb.Admin.DashboardLive do
  use ChimeraCmsWeb, :live_view

  alias ChimeraCms.Blog
  alias ChimeraCms.Portfolio
  alias ChimeraCms.Resume

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Blog.subscribe()
      Portfolio.subscribe()
      Resume.subscribe()
    end

    socket =
      socket
      |> assign_stats()
      |> assign(:page_title, "Dashboard")

    {:ok, socket}
  end

  @impl true
  def handle_info({:blog_post_created, _post}, socket) do
    {:noreply, assign_stats(socket)}
  end

  @impl true
  def handle_info({:blog_post_updated, _post}, socket) do
    {:noreply, assign_stats(socket)}
  end

  @impl true
  def handle_info({:blog_post_deleted, _post}, socket) do
    {:noreply, assign_stats(socket)}
  end

  @impl true
  def handle_info({:project_created, _project}, socket) do
    {:noreply, assign_stats(socket)}
  end

  @impl true
  def handle_info({:project_updated, _project}, socket) do
    {:noreply, assign_stats(socket)}
  end

  @impl true
  def handle_info({:project_deleted, _project}, socket) do
    {:noreply, assign_stats(socket)}
  end

  @impl true
  def handle_info({:work_experience_created, _work_experience}, socket) do
    {:noreply, assign_stats(socket)}
  end

  @impl true
  def handle_info({:work_experience_updated, _work_experience}, socket) do
    {:noreply, assign_stats(socket)}
  end

  @impl true
  def handle_info({:work_experience_deleted, _work_experience}, socket) do
    {:noreply, assign_stats(socket)}
  end

  defp assign_stats(socket) do
    posts = Blog.list_posts()
    projects = Portfolio.list_projects()
    work_experiences = Resume.list_work_experiences()

    socket
    |> assign(:total_posts, length(posts))
    |> assign(:published_posts, Enum.count(posts, & &1.published))
    |> assign(:draft_posts, Enum.count(posts, &(not &1.published)))
    |> assign(:total_projects, length(projects))
    |> assign(:featured_projects, Enum.count(projects, & &1.featured))
    |> assign(:total_work_experiences, length(work_experiences))
    |> assign(:recent_posts, Enum.take(posts, 5))
    |> assign(:recent_projects, Enum.take(projects, 5))
    |> assign(:recent_work_experiences, Enum.take(work_experiences, 5))
  end
end
