
#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

PID_FILE=".pfa10.pid"
LOG_FILE="pfa10.log"
HOST="0.0.0.0"
PORT="8000"

is_running() {
    if [[ ! -f "$PID_FILE" ]]; then
        return 1
    fi

    PID=$(cat "$PID_FILE")

    if [[ ! -r "/proc/$PID/cmdline" ]]; then
        return 1
    fi

    CMD=$(tr '\0' ' ' < "/proc/$PID/cmdline")

    [[ "$CMD" == *"uvicorn main:app"* ]]
}

start() {
    if is_running; then
        echo "PFA-10 fonctionne deja."
        return
    fi

    if [[ ! -x ".venv/bin/uvicorn" ]]; then
        echo "Erreur : environnement Python absent."
        exit 1
    fi

    nohup .venv/bin/uvicorn main:app \
        --host "$HOST" --port "$PORT" \
        >> "$LOG_FILE" 2>&1 &

    echo $! > "$PID_FILE"
    sleep 2

    if is_running && curl -fsS \
        "http://$HOST:$PORT/health" > /dev/null; then
        echo "PFA-10 demarre avec succes."
    else
        echo "Erreur : demarrage non confirme."
        exit 1
    fi
}

stop() {
    if ! is_running; then
        echo "PFA-10 n'est pas en cours d'execution."
        rm -f "$PID_FILE"
        return
    fi

    PID=$(cat "$PID_FILE")
    kill -TERM "$PID"

    for i in {1..20}; do
        if ! kill -0 "$PID" 2>/dev/null; then
            rm -f "$PID_FILE"
            echo "PFA-10 arrete proprement."
            return
        fi
        sleep 1
    done

    echo "Arret non confirme : verifier le processus."
    exit 1
}

status() {
    if is_running; then
        echo "PFA-10 : RUNNING (PID $(cat "$PID_FILE"))"
    else
        echo "PFA-10 : STOPPED"
    fi
}

case "${1:-}" in
    start) start ;;
    stop) stop ;;
    restart)
        stop
        start
        ;;
    status) status ;;
    logs) tail -n 30 "$LOG_FILE" ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs}"
        exit 1
        ;;
esac
