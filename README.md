# PFA-10 — Cybersecurity Incident Ticketing Platform

Projet PFA EMSI développé par Ilyas et Badr.

## Objectif

Développer une plateforme de gestion automatisée des
incidents de cybersécurité à partir de données réelles.

## Sources

- Windows Event Log et Sysmon
- Linux journald et Auditd
- Zabbix pour la supervision

## Architecture

- FastAPI : API centrale
- SQLite / SQLAlchemy : stockage de la plateforme
- Docker Compose : déploiement
- Agents natifs : collecte Windows/Linux

## Organisation

- app/ : application centrale
- agents/ : futurs collecteurs natifs
- zabbix/ : intégration Zabbix
- scripts/ : automatisation
- tests/ : tests
- docs/ : documentation

## État

Sprint 0 : preuve de faisabilité réalisée.
Sprint 1 : infrastructure et automatisation initiale.
