defmodule Dallas.Router do
  defmacro dallas_dashboard(path, opts \\ []) do
    opts =
      if Macro.quoted_literal?(opts) do
        Macro.prewalk(opts, &expand_alias(&1, __CALLER__))
      else
        opts
      end

    quote bind_quoted: binding() do
      scope path, alias: false, as: false do
        {session_name, session_opts, route_opts} =
          Dallas.Router.__options__(opts, path)

        import Phoenix.Router, only: [get: 4]
        import Phoenix.LiveView.Router, only: [live: 4, live_session: 3]

        live_session session_name, session_opts do
          # LiveDashboard assets
          get "/css-:md5", Dallas.Assets, :css, as: :dallas_asset
          get "/js-:md5", Dallas.Assets, :js, as: :dallas_asset

          # All helpers are public contracts and cannot be changed
          live "/", Dallas.DashboardLive, :dashboard, route_opts
          live "/:path", Dallas.DashboardLive, :dashboard, route_opts
        end
      end

      unless Module.get_attribute(__MODULE__, :dallas_prefix) do
        @dallas_prefix Phoenix.Router.scoped_path(__MODULE__, path)
                               |> String.replace_suffix("/", "")
        def __dallas_prefix__, do: @dallas_prefix
      end
    end
  end

  defp expand_alias({:__aliases__, _, _} = alias, env),
    do: Macro.expand(alias, %{env | function: {:live_dashboard, 2}})

  defp expand_alias(other, _env), do: other


  def __options__(options, path) do
    live_socket_path = Keyword.get(options, :live_socket_path, "/live")

    csp_nonce_assign_key =
      case options[:csp_nonce_assign_key] do
        nil -> nil
        key when is_atom(key) -> %{img: key, style: key, script: key}
        %{} = keys -> Map.take(keys, [:img, :style, :script])
      end

    {
      options[:live_session_name] || :dallas,
      [
        session: {__MODULE__, :__session__, [options, csp_nonce_assign_key]},
        root_layout: {Dallas.LayoutView, :dash},
        on_mount: options[:on_mount] || nil
      ],
      [
        private: %{
          live_socket_path: live_socket_path,
          csp_nonce_assign_key: csp_nonce_assign_key,
          dallas_prefix: path
        },
        as: :dallas
      ]
    }
  end

  def __session__(conn, options, csp_nonce_assign_key) do
    %{
      "csp_nonces" => %{
        img: conn.assigns[csp_nonce_assign_key[:img]],
        style: conn.assigns[csp_nonce_assign_key[:style]],
        script: conn.assigns[csp_nonce_assign_key[:script]]
      }
    }
  end
end
