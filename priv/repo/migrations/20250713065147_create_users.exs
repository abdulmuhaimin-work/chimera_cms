defmodule ChimeraCms.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password_hash, :string
      add :first_name, :string
      add :last_name, :string
      add :role, :string
      add :active, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
  end
end
