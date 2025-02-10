defmodule DallasWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use DallasWeb, :controller
      use DallasWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths,
    do:
      ~w(assets fonts images favicon.ico favicon_ops_light.png favicon_ops_dark.png robots.txt sheet-examples audio)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: DallasWeb.Layouts]

      import Plug.Conn
      use Gettext, backend: DallasWeb.Gettext

      unquote(verified_routes())

      def current_user(conn) do
        conn.assigns[:current_user]
      end
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView, container: {:div, class: "h-full"}

      # on_mount DallasWeb.GlobalFlash

      import DallasWeb, only: [push_close_modal: 2]

      unquote(html_helpers())
    end
  end

  def public_live_view do
    quote do
      use Phoenix.LiveView, container: {:div, class: "h-full"}

      # on_mount DallasWeb.GlobalFlash

      import DallasWeb, only: [push_close_modal: 2]
      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      # import DallasWeb.GlobalFlash, only: [put_flash!: 3, clear_flash!: 1, clear_flash!: 2]
      import DallasWeb, only: [push_close_modal: 2]

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components and translation
      # import DallasWeb.CoreComponents
      # import DallasWeb.AppComponents
      import DallasWeb.LiveHelpers
      # use Gettext, backend: DallasWeb.Gettext

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      defp ok(socket) do
        {:ok, socket}
      end

      defp noreply(socket) do
        {:noreply, socket}
      end

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: DallasWeb.Endpoint,
        router: DallasWeb.Router,
        statics: DallasWeb.static_paths()
    end
  end

  def push_close_modal(socket, modal_id) do
    Phoenix.LiveView.push_event(socket, "js-exec", %{
      to: "##{modal_id}",
      attr: "phx-remove"
    })
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
