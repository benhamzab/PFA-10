
from fastapi import FastAPI
from typing import Any

app = FastAPI(title="PFA-10 Cybersecurity Platform")

@app.get("/")
def home():
    return {"message": "PFA-10 API operational"}

@app.get("/health")
def health():
    return {"status": "healthy"}

@app.post("/events")
def receive_event(event: dict[str, Any]):
    print(f"Event received: {event}", flush=True)
    return {
        "status": "received",
        "event": event
    }


@app.post("/zabbix/webhook")
def receive_zabbix_alert(alert: dict[str, Any]):
    """Endpoint de preuve de faisabilité Sprint 0."""
    required = ("event_id", "host", "status")

    missing = [field for field in required if not alert.get(field)]
    if missing:
        return {"status": "rejected", "missing_fields": missing}

    print(
        f"[ZABBIX] event_id={alert['event_id']} "
        f"host={alert['host']} "
        f"status={alert['status']} "
        f"trigger={alert.get('trigger', '')}",
        flush=True
    )

    return {
        "status": "received",
        "source": "zabbix",
        "event_id": alert["event_id"]
    }
