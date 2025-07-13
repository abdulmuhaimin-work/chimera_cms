defmodule ChimeraCms.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :active, :boolean, default: true
    field :role, :string, default: "admin"
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :first_name, :string
    field :last_name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :role, :active])
    |> validate_required([:email, :first_name, :last_name])
    |> validate_email()
    |> unique_constraint(:email)
  end

  @doc """
  Changeset for user registration with password
  """
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :first_name, :last_name, :role, :active])
    |> validate_required([:email, :password, :first_name, :last_name])
    |> validate_email()
    |> validate_password()
    |> unique_constraint(:email)
  end

  @doc """
  Changeset for password updates
  """
  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_password()
  end

  def login_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+\.[^\s]+$/, message: "must be a valid email address")
    |> validate_length(:email, max: 160)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_length(:password, min: 6, max: 100)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Pbkdf2.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset

  @doc """
  Verifies a user's password
  """
  def verify_password(user, password) do
    Pbkdf2.verify_pass(password, user.password_hash)
  end
end
