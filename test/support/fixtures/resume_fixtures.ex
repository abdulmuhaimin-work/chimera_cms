defmodule ChimeraCms.ResumeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ChimeraCms.Resume` context.
  """

  @doc """
  Generate a work_experience.
  """
  def work_experience_fixture(attrs \\ %{}) do
    {:ok, work_experience} =
      attrs
      |> Enum.into(%{
        company: "some company",
        description: "some description",
        period: "some period",
        sort_order: 42,
        technologies: ["option1", "option2"],
        title: "some title"
      })
      |> ChimeraCms.Resume.create_work_experience()

    work_experience
  end
end
