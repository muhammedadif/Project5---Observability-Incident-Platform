# Incident Alerting Flow

## Overview

The observability platform uses Prometheus and Alertmanager to detect
Kubernetes application incidents and send email notifications.

## Alert Flow

Kubernetes
    ↓
kube-state-metrics
    ↓
Prometheus
    ↓
PrometheusRule
    ↓
Alertmanager
    ↓
Gmail SMTP
    ↓
Email Notification

## Example Incident

The `PetclinicPodNotRunning` alert monitors pods in the
`petclinic-helm` namespace.

The alert fires when a pod remains in a non-Running state for 2 minutes.

## Alertmanager

Alertmanager receives the alert from Prometheus and routes it to the
configured email receiver.

The Gmail SMTP server is:

smtp.gmail.com:587

The Gmail App Password is stored in a Kubernetes Secret and is not
stored in Git.

## Notification

When the alert fires, Alertmanager sends a firing notification.

When the incident is resolved, Alertmanager sends a resolved notification.

The route uses:

- group wait: 10 seconds
- group interval: 5 minutes
- repeat interval: 4 hours

Therefore, resolved notifications may be delivered after a short delay
because of Alertmanager's grouping behavior.

## Validation

The alerting pipeline was tested by creating an intentionally
unschedulable Kubernetes pod.

The test successfully produced:

- Prometheus firing alert
- Alertmanager notification
- Gmail firing email
- Alert resolution
- Gmail resolved email

## Security

The Gmail App Password is stored in the Kubernetes Secret:

`alertmanager-smtp`

The credential is not stored in Git.
