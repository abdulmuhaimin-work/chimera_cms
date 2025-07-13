defmodule ChimeraCmsWeb.Admin.ProjectJSON do
  @doc """
  Renders a list of projects.
  """
  def index(%{projects: projects}) do
    %{data: for(project <- projects, do: data(project))}
  end

  @doc """
  Renders a single project.
  """
  def show(%{project: project}) do
    %{data: data(project)}
  end

  defp data(%ChimeraCms.Portfolio.Project{} = project) do
    %{
      id: project.id,
      title: project.title,
      description: project.description,
      overview: project.overview,
      problem: project.problem,
      solution: project.solution,
      outcome: project.outcome,
      tags: project.tags,
      tech_stack: project.tech_stack,
      image: project.image,
      repo_url: project.repo_url,
      live_url: project.live_url,
      timeline: project.timeline,
      role: project.role,
      client: project.client,
      featured: project.featured,
      sort_order: project.sort_order,
      inserted_at: project.inserted_at,
      updated_at: project.updated_at
    }
  end
end
