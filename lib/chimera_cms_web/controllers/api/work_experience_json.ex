defmodule ChimeraCmsWeb.Api.WorkExperienceJSON do
  @doc """
  Renders a list of work experiences.
  """
  def index(%{work_experiences: work_experiences}) do
    %{data: for(work_experience <- work_experiences, do: data(work_experience))}
  end

  @doc """
  Renders a single work experience.
  """
  def show(%{work_experience: work_experience}) do
    %{data: data(work_experience)}
  end

  defp data(%ChimeraCms.Resume.WorkExperience{} = work_experience) do
    %{
      id: work_experience.id,
      title: work_experience.title,
      company: work_experience.company,
      period: work_experience.period,
      description: work_experience.description,
      technologies: work_experience.technologies,
      sort_order: work_experience.sort_order,
      inserted_at: work_experience.inserted_at,
      updated_at: work_experience.updated_at
    }
  end
end
