defmodule LiveAppWeb.Router do
  use LiveAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveAppWeb do
    pipe_through :browser

    live "/", Lead.NewLive
    live "/leads", Lead.IndexLive
  end
end
