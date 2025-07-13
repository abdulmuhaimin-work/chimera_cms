defmodule ChimeraCms.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :chimera_cms,
    module: ChimeraCms.Auth.Guardian,
    error_handler: ChimeraCms.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
