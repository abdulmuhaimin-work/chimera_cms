defmodule ChimeraCms.Auth.Pipeline do
  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> Guardian.Plug.VerifyHeader.call(Guardian.Plug.VerifyHeader.init(scheme: "Bearer"))
    |> Guardian.Plug.EnsureAuthenticated.call(Guardian.Plug.EnsureAuthenticated.init([]))
    |> Guardian.Plug.LoadResource.call(Guardian.Plug.LoadResource.init([]))
  end
end
