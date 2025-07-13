defmodule ChimeraCms.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :slug, :string
      add :content, :text
      add :excerpt, :text
      add :featured_image, :string
      add :published, :boolean, default: false, null: false
      add :published_at, :utc_datetime
      add :tags, {:array, :string}

      timestamps(type: :utc_datetime)
    end

    create unique_index(:posts, [:slug])
  end
end
