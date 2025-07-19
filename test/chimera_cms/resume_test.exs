defmodule ChimeraCms.ResumeTest do
  use ChimeraCms.DataCase

  alias ChimeraCms.Resume

  describe "work_experiences" do
    alias ChimeraCms.Resume.WorkExperience

    import ChimeraCms.ResumeFixtures

    @invalid_attrs %{description: nil, title: nil, period: nil, company: nil, technologies: nil, sort_order: nil}

    test "list_work_experiences/0 returns all work_experiences" do
      work_experience = work_experience_fixture()
      assert Resume.list_work_experiences() == [work_experience]
    end

    test "get_work_experience!/1 returns the work_experience with given id" do
      work_experience = work_experience_fixture()
      assert Resume.get_work_experience!(work_experience.id) == work_experience
    end

    test "create_work_experience/1 with valid data creates a work_experience" do
      valid_attrs = %{description: "some description", title: "some title", period: "some period", company: "some company", technologies: ["option1", "option2"], sort_order: 42}

      assert {:ok, %WorkExperience{} = work_experience} = Resume.create_work_experience(valid_attrs)
      assert work_experience.description == "some description"
      assert work_experience.title == "some title"
      assert work_experience.period == "some period"
      assert work_experience.company == "some company"
      assert work_experience.technologies == ["option1", "option2"]
      assert work_experience.sort_order == 42
    end

    test "create_work_experience/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resume.create_work_experience(@invalid_attrs)
    end

    test "update_work_experience/2 with valid data updates the work_experience" do
      work_experience = work_experience_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", period: "some updated period", company: "some updated company", technologies: ["option1"], sort_order: 43}

      assert {:ok, %WorkExperience{} = work_experience} = Resume.update_work_experience(work_experience, update_attrs)
      assert work_experience.description == "some updated description"
      assert work_experience.title == "some updated title"
      assert work_experience.period == "some updated period"
      assert work_experience.company == "some updated company"
      assert work_experience.technologies == ["option1"]
      assert work_experience.sort_order == 43
    end

    test "update_work_experience/2 with invalid data returns error changeset" do
      work_experience = work_experience_fixture()
      assert {:error, %Ecto.Changeset{}} = Resume.update_work_experience(work_experience, @invalid_attrs)
      assert work_experience == Resume.get_work_experience!(work_experience.id)
    end

    test "delete_work_experience/1 deletes the work_experience" do
      work_experience = work_experience_fixture()
      assert {:ok, %WorkExperience{}} = Resume.delete_work_experience(work_experience)
      assert_raise Ecto.NoResultsError, fn -> Resume.get_work_experience!(work_experience.id) end
    end

    test "change_work_experience/1 returns a work_experience changeset" do
      work_experience = work_experience_fixture()
      assert %Ecto.Changeset{} = Resume.change_work_experience(work_experience)
    end
  end
end
