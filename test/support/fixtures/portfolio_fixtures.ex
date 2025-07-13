defmodule ChimeraCms.PortfolioFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ChimeraCms.Portfolio` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        client: "some client",
        description: "some description",
        featured: true,
        image: "some image",
        live_url: "some live_url",
        outcome: "some outcome",
        overview: "some overview",
        problem: "some problem",
        repo_url: "some repo_url",
        role: "some role",
        solution: "some solution",
        sort_order: 42,
        tags: ["option1", "option2"],
        tech_stack: ["option1", "option2"],
        timeline: "some timeline",
        title: "some title"
      })
      |> ChimeraCms.Portfolio.create_project()

    project
  end
end
