defmodule ChimeraCms.Resume.WorkExperience do
  use Ecto.Schema
  import Ecto.Changeset

  schema "work_experiences" do
    field :description, :string
    field :title, :string
    field :period, :string
    field :company, :string
    field :technologies, {:array, :string}
    field :sort_order, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(work_experience, attrs) do
    work_experience
    |> cast(attrs, [:title, :company, :period, :description, :technologies, :sort_order])
    |> validate_required([:title, :company, :period, :description])
    |> validate_length(:title, min: 1, max: 255)
    |> validate_length(:company, min: 1, max: 255)
    |> validate_length(:period, min: 1, max: 100)
    |> validate_length(:description, min: 10, max: 2000)
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
