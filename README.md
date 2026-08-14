# Observability & Incident Response Platform

A production-style observability platform for monitoring Kubernetes workloads, visualizing system and application health, detecting incidents, and supporting incident investigation and recovery.

## Project Goal

Build an end-to-end observability and incident response workflow covering:

- Kubernetes and infrastructure monitoring
- Application metrics
- Centralized logging
- Dashboards
- Alerting and notifications
- SLI/SLO monitoring
- Incident simulation
- Incident investigation
- Incident recovery and validation
- Operational documentation and runbooks

## Observability Flow

Application & Kubernetes
        ↓
Metrics + Logs
        ↓
Prometheus + Loki + Alloy
        ↓
Grafana
        ↓
Prometheus Alerting
        ↓
Alertmanager
        ↓
Incident Detection
        ↓
Investigation
        ↓
Recovery
        ↓
Validation

## Core Technologies

- AWS EKS
- Kubernetes
- Helm
- Prometheus
- Grafana
- Alertmanager
- Loki
- Alloy
- Docker
- Terraform
[O- GitHub

## Project Focus

The project follows a production-style operational workflow:

Monitor → Detect → Investigate → Recover → Validate

## Incident Workflow

The platform was tested using an intentional PetClinic Gateway availability incident.

The workflow included:

1. Incident simulation
2. Incident detection
3. Kubernetes investigation
4. Prometheus metric analysis
5. SLI/SLO analysis
6. Root-cause identification
7. Service recovery
8. Recovery validation
9. Production validation

## SLI / SLO

PetClinic Gateway availability is monitored using HTTP request metrics.

- SLO: 99.9% availability
- Error budget: 0.1%
- SLI: Successful requests / Total requests
- Critical burn-rate alert: 14.4x
- Warning burn-rate alert: 6x

## Repository Structure

```text
observability-incident-platform/
├── logging/
│   ├── alloy/
│   ├── loki/
│   └── terraform/
├── monitoring/
│   ├── alertmanager/
│   ├── alerts/
│   └── servicemonitors/
├── docs/
│   ├── alerting-flow.md
│   ├── slo-design.md
│   ├── incident-postmortem.md
│   ├── incident-investigation.md
│   ├── incident-validation.md
│   ├── production_validation.md
│   ├── project-validation.md
│   └── infrastructure-cleanup.md
├── runbooks/
│   ├── incident-recovery.md
│   └── operational-troubleshooting.md
├── .gitignore
└── README.md
