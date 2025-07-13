defmodule ChimeraCms.PortfolioTest do
  use ChimeraCms.DataCase

  alias ChimeraCms.Portfolio

  describe "projects" do
    alias ChimeraCms.Portfolio.Project

    import ChimeraCms.PortfolioFixtures

    @invalid_attrs %{description: nil, title: nil, image: nil, role: nil, client: nil, repo_url: nil, overview: nil, problem: nil, solution: nil, outcome: nil, tags: nil, tech_stack: nil, live_url: nil, timeline: nil, featured: nil, sort_order: nil}

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Portfolio.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Portfolio.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      valid_attrs = %{description: "some description", title: "some title", image: "some image", role: "some role", client: "some client", repo_url: "some repo_url", overview: "some overview", problem: "some problem", solution: "some solution", outcome: "some outcome", tags: ["option1", "option2"], tech_stack: ["option1", "option2"], live_url: "some live_url", timeline: "some timeline", featured: true, sort_order: 42}

      assert {:ok, %Project{} = project} = Portfolio.create_project(valid_attrs)
      assert project.description == "some description"
      assert project.title == "some title"
      assert project.image == "some image"
      assert project.role == "some role"
      assert project.client == "some client"
      assert project.repo_url == "some repo_url"
      assert project.overview == "some overview"
      assert project.problem == "some problem"
      assert project.solution == "some solution"
      assert project.outcome == "some outcome"
      assert project.tags == ["option1", "option2"]
      assert project.tech_stack == ["option1", "option2"]
      assert project.live_url == "some live_url"
      assert project.timeline == "some timeline"
      assert project.featured == true
      assert project.sort_order == 42
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Portfolio.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", image: "some updated image", role: "some updated role", client: "some updated client", repo_url: "some updated repo_url", overview: "some updated overview", problem: "some updated problem", solution: "some updated solution", outcome: "some updated outcome", tags: ["option1"], tech_stack: ["option1"], live_url: "some updated live_url", timeline: "some updated timeline", featured: false, sort_order: 43}

      assert {:ok, %Project{} = project} = Portfolio.update_project(project, update_attrs)
      assert project.description == "some updated description"
      assert project.title == "some updated title"
      assert project.image == "some updated image"
      assert project.role == "some updated role"
      assert project.client == "some updated client"
      assert project.repo_url == "some updated repo_url"
      assert project.overview == "some updated overview"
      assert project.problem == "some updated problem"
      assert project.solution == "some updated solution"
      assert project.outcome == "some updated outcome"
      assert project.tags == ["option1"]
      assert project.tech_stack == ["option1"]
      assert project.live_url == "some updated live_url"
      assert project.timeline == "some updated timeline"
      assert project.featured == false
      assert project.sort_order == 43
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Portfolio.update_project(project, @invalid_attrs)
      assert project == Portfolio.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Portfolio.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Portfolio.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Portfolio.change_project(project)
    end
  end
end
