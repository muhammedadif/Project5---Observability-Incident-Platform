# PetClinic Incident Recovery & Validation

## Recovery Objective

Restore the PetClinic Gateway after the simulated availability incident and verify that the complete application and observability path is healthy.

## Recovery Action

The Gateway Deployment was restored to 2 replicas:

```bash
kubectl scale deployment petclinic-gateway \
  -n petclinic-helm \
  --replicas=2
```
## 3. Kubernetes Validation

After recovery:

- Deployment: `2/2` available
- Gateway Pods: `2/2` Running
- Service: available
- EndpointSlice: 2 ready endpoints

## 4. Prometheus Validation

Prometheus successfully detected both Gateway pods.

```text
10.0.101.122:8080 → up=1
10.0.102.38:8080  → up=1
```

## 5. Application Validation

The Gateway was tested after recovery:

```bash
curl -i http://localhost:8080/
```

## 6. SLI Validation

Application traffic was generated after recovery.

The availability SLI resumed producing data and returned to:

```text
100% availability
```

## 7. Recovery Validation Summary

| Check | Result |
|---|---|
| Deployment | 2/2 available |
| Pods | 2/2 Running |
| Service | Healthy |
| Endpoints | 2 ready |
| Prometheus targets | UP |
| Application | HTTP 200 |
| Request metrics | Resumed |
| Availability SLI | 100% |

## 8. Conclusion

The PetClinic Gateway was successfully recovered and validated across the Kubernetes, application, and observability layers.
