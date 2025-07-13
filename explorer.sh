#!/bin/bash

APP="_build/prod/rel/blockscout/bin/blockscout"

case "$1" in
  start)
    echo "🚀 Starte BlockScout im Hintergrund…"
    $APP start
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
    $APP start
    ;;

  *)
    echo "❌ Ungültiger Befehl. Nutze:"
    echo "   $0 start   # Startet BlockScout"
    echo "   $0 stop    # Stoppt BlockScout"
    echo "   $0 reset   # Löscht und migriert DB, startet neu"
    exit 1
    ;;
esac
