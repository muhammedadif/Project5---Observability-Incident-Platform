# PetClinic Incident Recovery Runbook

## Purpose

Provide a quick procedure for restoring the PetClinic Gateway after an availability incident.

## 1. Check Current State

Run:

    kubectl get deployment -n petclinic-helm petclinic-gateway
    kubectl get pods -n petclinic-helm -l app=petclinic-gateway

Confirm the current number of replicas and pod state.

## 2. Restore Replicas

If the Gateway has been scaled down:

    kubectl scale deployment petclinic-gateway \
      -n petclinic-helm \
      --replicas=2

## 3. Validate Pods

Run:

    kubectl get pods -n petclinic-helm -l app=petclinic-gateway

Expected:

    2/2 Running

## 4. Validate Service Endpoints

Run:

    kubectl get svc -n petclinic-helm petclinic-gateway

    kubectl get endpointslice -n petclinic-helm \
      -l kubernetes.io/service-name=petclinic-gateway

Confirm ready Gateway endpoints are available.

## 5. Validate Prometheus

Run:

    curl -sG http://localhost:9090/api/v1/query \
      --data-urlencode 'query=up{namespace="petclinic-helm",job="petclinic-gateway"}'

Expected:

    up = 1

for the Gateway targets.

## 6. Validate Application

Run:

    curl -i http://localhost:8080/

Expected:

    HTTP/1.1 200 OK

## 7. Validate SLI

Generate application traffic if required, then run:

    curl -sG http://localhost:9090/api/v1/query \
      --data-urlencode 'query=petclinic:sli_availability:ratio'

Confirm the availability SLI is producing healthy data.

## 8. Recovery Complete

Recovery is complete when:

- Gateway replicas are healthy.
- Pods are Running and Ready.
- Service endpoints are available.
- Prometheus targets are UP.
- Application returns HTTP 200.
- Application metrics resume.
- Availability SLI returns to a healthy state.
