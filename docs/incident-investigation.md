# PetClinic Incident Investigation

## Investigation Objective

Identify the cause of the PetClinic Gateway availability incident using Kubernetes, Prometheus, SLI, and alerting data.

## Investigation Checks

The incident was investigated through:

1. Deployment and Pod state
2. Service and EndpointSlice state
3. Prometheus target health
4. Application request metrics
5. SLI state
6. Kubernetes events
7. SLO alert state

## Key Findings

- Gateway Deployment had `0` desired replicas during the incident.
- Gateway Pods were terminated.
- Gateway Service configuration was correct.
- No Gateway endpoints were available while replicas were `0`.
- Prometheus Gateway targets disappeared.
- Application request metrics became unavailable.
- SLI data became unavailable because there was no request traffic.
- Kubernetes events confirmed the ReplicaSet was scaled from `2` to `0`.
- SLO burn-rate alerts remained inactive because there was no request traffic.

## Root Cause

The confirmed root cause was the `petclinic-gateway` Deployment being scaled from `2` replicas to `0` replicas.

The Service, Prometheus configuration, and application itself were not identified as the root cause.

## Additional Finding

The Gateway HPA reported:

`FailedGetResourceMetric`

because the `pods.metrics.k8s.io` resource metrics API was unavailable.

This was identified as a separate infrastructure issue and was not the cause of the simulated incident.

## Investigation Conclusion

The investigation successfully correlated Kubernetes state, events, Prometheus metrics, SLI data, and alerting behavior to identify the root cause of the simulated Gateway outage.
