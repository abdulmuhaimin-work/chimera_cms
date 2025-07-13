defmodule ChimeraCms.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ChimeraCms.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        active: true,
        email: unique_user_email(),
        first_name: "some first_name",
        last_name: "some last_name",
        password_hash: "some password_hash",
        role: "some role"
      })
      |> ChimeraCms.Accounts.create_user()

    user
  end
end
