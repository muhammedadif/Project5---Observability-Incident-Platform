# PetClinic Gateway Availability Incident

## Incident Summary

PetClinic Gateway became unavailable after the deployment was scaled from 2 replicas to 0 replicas.

The incident was detected through Kubernetes events and Prometheus observability data. The gateway deployment was restored to 2 replicas, application connectivity was restored, and the SLI returned to 100% availability.

---

## Incident Impact

- PetClinic Gateway had 0 available replicas.
- Application traffic could not reach the gateway.
- HTTP request metrics disappeared while the gateway was unavailable.
- The PetClinic availability SLI had no usable request data during the outage.
- No permanent application or infrastructure damage occurred.

---

## Incident Timeline

### 1. Incident Injection

The PetClinic Gateway deployment was scaled down to zero replicas.

```bash
kubectl scale deployment petclinic-gateway \
  -n petclinic-helm \
  --replicas=0
