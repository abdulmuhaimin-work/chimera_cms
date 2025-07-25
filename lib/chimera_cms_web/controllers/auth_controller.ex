defmodule ChimeraCmsWeb.AuthController do
  use ChimeraCmsWeb, :controller

  alias ChimeraCms.Accounts

  def login_form(conn, _params) do
    changeset = Accounts.change_user_login(%{})
    render(conn, :login_form, changeset: changeset)
  end

  def login(conn, %{"user" => user_params}) do
    case Accounts.authenticate_user(user_params["email"], user_params["password"]) do
      {:ok, user} ->
        {:ok, token, _claims} = ChimeraCms.Guardian.encode_and_sign(user)

        conn
        |> put_session(:user_token, token)
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: ~p"/admin")

      {:error, :invalid_credentials} ->
        changeset = Accounts.change_user_login(user_params)
        |> Ecto.Changeset.add_error(:email, "Invalid email or password")

        conn
        |> put_flash(:error, "Invalid email or password")
        |> render(:login_form, changeset: changeset)
    end
  end

  def logout(conn, _params) do
    conn
    |> clear_session()
    |> put_flash(:info, "Logged out successfully")
    |> redirect(to: ~p"/auth/login")
  end

  def me(conn, _params) do
    user = conn.assigns[:current_user]

    if user do
      conn
      |> put_status(:ok)
      |> json(%{
        user: %{
          id: user.id,
          email: user.email,
          first_name: user.first_name,
          last_name: user.last_name,
          role: user.role
        }
      })
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Not authenticated"})
    end
  end
end
