# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

[__DIR__ | ~w(.. .. .. config config_helper.exs)]
|> Path.join()
|> Code.eval_file()

# General application configuration
config :block_scout_web,
  namespace: BlockScoutWeb,
  ecto_repos: ConfigHelper.repos(),
  cookie_domain: System.get_env("SESSION_COOKIE_DOMAIN"),
  # 604800 seconds, 1 week
  session_cookie_ttl: 60 * 60 * 24 * 7,
  invalid_session_key: "invalid_session",
  api_v2_temp_token_key: "api_v2_temp_token",
  http_adapter: HTTPoison

config :block_scout_web,
  admin_panel_enabled: ConfigHelper.parse_bool_env_var("ADMIN_PANEL_ENABLED")

config :block_scout_web,
  disable_api?: ConfigHelper.parse_bool_env_var("DISABLE_API")

config :block_scout_web, BlockScoutWeb.Counters.BlocksIndexedCounter, enabled: true

config :block_scout_web, BlockScoutWeb.Counters.InternalTransactionsIndexedCounter, enabled: true

config :block_scout_web, BlockScoutWeb.Tracer,
  service: :block_scout_web,
  adapter: SpandexDatadog.Adapter,
  trace_key: :blockscout

# Configures gettext
config :block_scout_web, BlockScoutWeb.Gettext, locales: ~w(en), default_locale: "en"

config :block_scout_web, BlockScoutWeb.SocialMedia,
  twitter: "PoaNetwork",
  telegram: "poa_network",
  facebook: "PoaNetwork",
  instagram: "PoaNetwork"

config :block_scout_web, BlockScoutWeb.Chain.TransactionHistoryChartController,
  # days
  history_size: 30

config :ex_cldr,
  default_locale: "en",
  default_backend: BlockScoutWeb.Cldr

config :logger, :block_scout_web,
  # keep synced with `config/config.exs`
  format: "$dateT$time $metadata[$level] $message\n",
  metadata:
    ~w(application fetcher request_id first_block_number last_block_number missing_block_range_count missing_block_count
       block_number step count error_count shrunk import_id transaction_id)a,
  metadata_filter: [application: :block_scout_web]

config :logger, :api,
  # keep synced with `config/config.exs`
  format: "$dateT$time $metadata[$level] $message\n",
  metadata:
    ~w(application fetcher request_id first_block_number last_block_number missing_block_range_count missing_block_count
       block_number step count error_count shrunk import_id transaction_id)a,
  metadata_filter: [application: :api]

config :logger, :api_v2,
  # keep synced with `config/config.exs`
  format: "$dateT$time $metadata[$level] $message\n",
  metadata:
    ~w(application fetcher request_id first_block_number last_block_number missing_block_range_count missing_block_count
       block_number step count error_count shrunk import_id transaction_id)a,
  metadata_filter: [application: :api_v2]

config :prometheus, BlockScoutWeb.Prometheus.PublicExporter,
  path: "/public-metrics",
  format: :auto,
  registry: :public,
  auth: false

config :prometheus, BlockScoutWeb.Prometheus.PhoenixInstrumenter,
  # override default for Phoenix 1.4 compatibility
  # * `:transport_name` to `:transport`
  # * remove `:vsn`
  channel_join_labels: [:channel, :topic, :transport],
  # override default for Phoenix 1.4 compatibility
  # * `:transport_name` to `:transport`
  # * remove `:vsn`
  channel_receive_labels: [:channel, :topic, :transport, :event]

config :spandex_phoenix, tracer: BlockScoutWeb.Tracer

config :block_scout_web, BlockScoutWeb.Routers.ApiRouter,
  writing_enabled: !ConfigHelper.parse_bool_env_var("API_V1_WRITE_METHODS_DISABLED"),
  reading_enabled: !ConfigHelper.parse_bool_env_var("API_V1_READ_METHODS_DISABLED")

config :block_scout_web, BlockScoutWeb.Routers.WebRouter, enabled: !ConfigHelper.parse_bool_env_var("DISABLE_WEBAPP")

config :block_scout_web, BlockScoutWeb.CSPHeader,
  mixpanel_url: System.get_env("MIXPANEL_URL", "https://api-js.mixpanel.com"),
  amplitude_url: System.get_env("AMPLITUDE_URL", "https://api2.amplitude.com/2/httpapi")

config :block_scout_web, Api.GraphQL,
  enabled: ConfigHelper.parse_bool_env_var("API_GRAPHQL_ENABLED", "true"),
  token_limit: ConfigHelper.parse_integer_env_var("API_GRAPHQL_TOKEN_LIMIT", 1000),
  max_complexity: ConfigHelper.parse_integer_env_var("API_GRAPHQL_MAX_COMPLEXITY", 100)

# Configures Ueberauth local settings
config :ueberauth, Ueberauth,
  providers: [
    auth0: {
      Ueberauth.Strategy.Auth0,
      [callback_path: "/auth/auth0/callback", callback_params: ["path"]]
    }
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
