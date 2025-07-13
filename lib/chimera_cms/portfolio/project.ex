defmodule ChimeraCms.Portfolio.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :description, :string
    field :title, :string
    field :image, :string
    field :role, :string
    field :client, :string
    field :repo_url, :string
    field :overview, :string
    field :problem, :string
    field :solution, :string
    field :outcome, :string
    field :tags, {:array, :string}
    field :tech_stack, {:array, :string}
    field :live_url, :string
    field :timeline, :string
    field :featured, :boolean, default: false
    field :sort_order, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:title, :description, :overview, :problem, :solution, :outcome, :tags, :tech_stack, :image, :repo_url, :live_url, :timeline, :role, :client, :featured, :sort_order])
    |> validate_required([:title, :description])
    |> validate_length(:title, min: 1, max: 255)
    |> validate_length(:description, min: 10, max: 1000)
    |> validate_format(:repo_url, ~r/^https?:\/\//, message: "must be a valid URL")
    |> validate_format(:live_url, ~r/^https?:\/\//, message: "must be a valid URL")
    |> put_sort_order()
  end

  defp put_sort_order(%Ecto.Changeset{valid?: true} = changeset) do
    case get_field(changeset, :sort_order) do
      nil -> put_change(changeset, :sort_order, 0)
      _ -> changeset
    end
  end

  defp put_sort_order(changeset), do: changeset
end
