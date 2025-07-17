#!/bin/bash

APP="_build/prod/rel/blockscout/bin/blockscout"
cp config/config_helper.exs "$RELDIR/releases/8.1.1/"
export DATABASE_URL="postgresql://xgradmin:xgradmin@localhost:5432/xgrscan"
export ECTO_USE_SSL=false

export ETHEREUM_JSONRPC_HTTP_URL="http://localhost:8545"
export ETHEREUM_JSONRPC_WS_URL="ws://localhost:8546"

export PORT=4000
export HOST=localhost

export NETWORK="XGRChain"
export SUBNETWORK="Mainnet"
export CHAIN_ID=1643



case "$1" in
  start)
    echo "🚀 Starte BlockScout im Hintergrund…"
    $APP start > blockscout.log 2>&1 & # & sorgt für Hintergrund
    ;;

  stop)
    echo "🛑 Stoppe BlockScout…"
    $APP stop
    ;;

  reset)
    echo "⚠️  Setze DB zurück und starte BlockScout neu…"
    $APP stop
    MIX_ENV=prod mix ecto.drop -y
    MIX_ENV=prod mix ecto.create
    MIX_ENV=prod mix ecto.migrate
    $APP start &
    ;;

  *)
    echo "❌ Ungültiger Befehl. Nutze:"
    echo "   $0 start   # Startet BlockScout"
    echo "   $0 stop    # Stoppt BlockScout"
    echo "   $0 reset   # Löscht und migriert DB, startet neu"
    exit 1
    ;;
esac

