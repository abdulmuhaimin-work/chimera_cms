defmodule ChimeraCms.Repo.Migrations.CreateWorkExperiences do
  use Ecto.Migration

  def change do
    create table(:work_experiences) do
      add :title, :string
      add :company, :string
      add :period, :string
      add :description, :text
      add :technologies, {:array, :string}
      add :sort_order, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
