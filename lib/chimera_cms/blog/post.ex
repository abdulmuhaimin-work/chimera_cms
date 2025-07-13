defmodule ChimeraCms.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :slug, :string
    field :content, :string
    field :excerpt, :string
    field :featured_image, :string
    field :published, :boolean, default: false
    field :published_at, :utc_datetime
    field :tags, {:array, :string}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :slug, :content, :excerpt, :featured_image, :published, :published_at, :tags])
    |> validate_required([:title, :content])
    |> validate_length(:title, min: 1, max: 255)
    |> validate_length(:excerpt, max: 500)
    |> put_slug()
    |> put_published_at()
    |> unique_constraint(:slug)
  end

  defp put_slug(%Ecto.Changeset{valid?: true, changes: %{title: title}} = changeset) do
    slug = title |> String.downcase() |> String.replace(~r/[^a-z0-9\s-]/, "") |> String.replace(~r/\s+/, "-")
    put_change(changeset, :slug, slug)
  end

  defp put_slug(changeset), do: changeset

  defp put_published_at(%Ecto.Changeset{valid?: true, changes: %{published: true}} = changeset) do
    case get_field(changeset, :published_at) do
      nil -> put_change(changeset, :published_at, DateTime.utc_now())
      _ -> changeset
    end
  end

  defp put_published_at(changeset), do: changeset
end
