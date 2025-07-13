defmodule ChimeraCms.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :title, :string
      add :description, :text
      add :overview, :text
      add :problem, :text
      add :solution, :text
      add :outcome, :text
      add :tags, {:array, :string}
      add :tech_stack, {:array, :string}
      add :image, :string
      add :repo_url, :string
      add :live_url, :string
      add :timeline, :string
      add :role, :string
      add :client, :string
      add :featured, :boolean, default: false, null: false
      add :sort_order, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
