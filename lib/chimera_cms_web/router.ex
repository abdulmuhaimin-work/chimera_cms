defmodule ChimeraCmsWeb.Router do
  use ChimeraCmsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ChimeraCmsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Corsica, origins: ["http://localhost:3000", "http://localhost:5173", "http://localhost:4173", "https://abdulmuhaimin.my/"]
  end

  pipeline :authenticated do
    plug ChimeraCmsWeb.Auth.Pipeline
  end

  pipeline :admin_layout do
    plug :put_root_layout, html: {ChimeraCmsWeb.Layouts, :admin}
  end

  scope "/", ChimeraCmsWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Public API routes
  scope "/api", ChimeraCmsWeb do
    pipe_through :api

    get "/posts", Api.PostController, :index
    get "/posts/:id", Api.PostController, :show
    get "/projects", Api.ProjectController, :index
    get "/projects/:id", Api.ProjectController, :show
  end

  # Authentication routes
  scope "/auth", ChimeraCmsWeb do
    pipe_through [:browser]

    get "/login", AuthController, :login_form
    post "/login", AuthController, :login
    get "/logout", AuthController, :logout
  end

  # Admin API routes (authenticated) - moved to /api/admin to avoid conflicts
  scope "/api/admin", ChimeraCmsWeb.Admin do
    pipe_through [:api, :authenticated]

    resources "/posts", PostController
    resources "/projects", ProjectController
    post "/upload", UploadController, :create
  end

  # Admin LiveView routes
  scope "/admin", ChimeraCmsWeb.Admin do
    pipe_through [:browser, :authenticated, :admin_layout]

    live "/", DashboardLive, :index
    live "/posts", PostsLive, :index
    live "/posts/new", PostsLive, :new
    live "/posts/:id/edit", PostsLive, :edit
    live "/posts/:id", PostsLive, :show
    live "/projects", ProjectsLive, :index
    live "/projects/new", ProjectsLive, :new
    live "/projects/:id/edit", ProjectsLive, :edit
    live "/projects/:id", ProjectsLive, :show
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:chimera_cms, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ChimeraCmsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
