# PetClinic Operational Troubleshooting Runbook

## Purpose

Quick reference for checking common PetClinic and observability issues.

## Kubernetes Health

Check nodes:

    kubectl get nodes

Check PetClinic pods:

    kubectl get pods -n petclinic-helm

Check recent events:

    kubectl get events -n petclinic-helm --sort-by='.lastTimestamp'

## Application Health

Check Gateway deployment:

    kubectl get deployment -n petclinic-helm petclinic-gateway

Check Gateway service:

    kubectl get svc -n petclinic-helm petclinic-gateway

Check Gateway endpoints:

    kubectl get endpointslice -n petclinic-helm \
      -l kubernetes.io/service-name=petclinic-gateway

Test the application:

    curl -i http://localhost:8080/

## Prometheus

Check Gateway target:

    curl -sG http://localhost:9090/api/v1/query \
      --data-urlencode 'query=up{namespace="petclinic-helm",job="petclinic-gateway"}'

Check application metrics:

    curl -sG http://localhost:9090/api/v1/query \
      --data-urlencode 'query=http_server_requests_seconds_count{namespace="petclinic-helm"}'

## SLI

Check availability:

    curl -sG http://localhost:9090/api/v1/query \
      --data-urlencode 'query=petclinic:sli_availability:ratio'

## Alerting

Check active alerts:

    curl -s http://localhost:9093/api/v2/alerts

Check Prometheus alert rules:

    curl -s http://localhost:9090/api/v1/rules?type=alert

## Basic Troubleshooting Flow

Application unavailable:

    Check Deployment
    → Check Pods
    → Check Service
    → Check EndpointSlice
    → Check Prometheus target
    → Check application metrics
    → Check Kubernetes events
    → Check SLI

If the issue is resolved, perform the recovery validation procedure.
