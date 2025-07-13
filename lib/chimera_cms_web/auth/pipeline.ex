defmodule ChimeraCmsWeb.Auth.Pipeline do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :current_user)
    token = get_session(conn, :user_token)

    if user_id && token do
      case verify_token(token) do
        {:ok, claims} ->
          if claims["sub"] == to_string(user_id) do
            user = ChimeraCms.Accounts.get_user!(user_id)
            assign(conn, :current_user, user)
          else
            redirect_to_login(conn)
          end
        {:error, _} ->
          redirect_to_login(conn)
      end
    else
      redirect_to_login(conn)
    end
  end

  defp verify_token(token) do
    ChimeraCms.Guardian.decode_and_verify(token)
  end

  defp redirect_to_login(conn) do
    conn
    |> clear_session()
    |> put_flash(:error, "You must be logged in to access this page")
    |> redirect(to: "/auth/login")
    |> halt()
  end
end
