# PetClinic SLO Design

## 1. Purpose

This document defines the Service Level Indicator (SLI), Service Level Objective (SLO), error budget, and burn-rate alerting strategy for the PetClinic application.

The SLO design is implemented using Prometheus recording rules and Prometheus alerting rules.

---

## 2. Service Being Measured

Application:

PetClinic

Kubernetes namespace:

petclinic-helm

The SLI measures HTTP requests handled by the PetClinic Gateway.

---

## 3. Service Level Indicator (SLI)

The primary SLI is HTTP request availability.

The application exposes request metrics through:

http_server_requests_seconds_count

The availability SLI is calculated as:

Good Requests / Total Requests

---

## 4. Request Selection

Application traffic is measured while excluding Spring Boot Actuator endpoints.

Excluded endpoints:

/actuator.*

This prevents health checks, information endpoints, and Prometheus scraping traffic from affecting the application's user-facing availability SLI.

---

## 5. Good Requests

A request is considered successful when:

outcome="SUCCESS"

The good request rate is calculated using:

sum(
  rate(
    http_server_requests_seconds_count{
      namespace="petclinic-helm",
      uri!~"/actuator.*",
      outcome="SUCCESS"
    }[5m]
  )
)

---

## 6. Total Requests

The total application request rate is calculated using:

sum(
  rate(
    http_server_requests_seconds_count{
      namespace="petclinic-helm",
      uri!~"/actuator.*"
    }[5m]
  )
)

The SLI calculations use a 5-minute rate window.

---

## 7. SLO Target

The PetClinic availability SLO is:

99.9%

Therefore:

SLO = 0.999

The target means that 99.9% of eligible application requests should be successful during the SLO evaluation period.

---

## 8. Error Budget

The error budget is the amount of failure allowed while still meeting the SLO.

Error Budget:

1 - SLO

1 - 0.999 = 0.001

Therefore:

Error Budget = 0.1%

This represents the maximum allowable unsuccessful-request ratio for the SLO.

---

## 9. Prometheus Recording Rules

The following recording rules were created:

petclinic:sli_requests:good_rate

petclinic:sli_requests:total_rate

petclinic:sli_availability:ratio

The availability ratio is calculated as:

good request rate / total request rate

These recording rules provide reusable SLI metrics for dashboards and alerting.

---

## 10. Burn Rate

Burn rate measures how quickly the service is consuming its available error budget.

Conceptually:

Burn Rate = Actual Error Rate / Allowed Error Rate

A burn rate of 1x represents the sustainable error rate allowed by the SLO.

Higher burn rates indicate that the error budget is being consumed more quickly.

---

## 11. Critical Burn-Rate Alert

Alert name:

PetclinicSLOBurnRateCritical

The critical alert requires both conditions:

5-minute burn rate >= 14.4x

AND

1-hour burn rate >= 14.4x

The alert must remain active for:

2 minutes

Severity:

critical

This identifies a rapid and sustained consumption of the SLO error budget.

---

## 12. Warning Burn-Rate Alert

Alert name:

PetclinicSLOBurnRateWarning

The warning alert requires both conditions:

30-minute burn rate >= 6x

AND

6-hour burn rate >= 6x

The alert must remain active for:

5 minutes

Severity:

warning

This identifies sustained error-budget consumption before it reaches the critical condition.

---

## 13. Alertmanager Integration

SLO alerts are sent from Prometheus to Alertmanager.

Alertmanager routes alerts through the configured email receiver.

The configured notification behavior includes:

- Gmail SMTP
- Warning and critical severities
- Resolved notifications

The Alertmanager integration was previously validated with both firing and resolved notifications.

---

## 14. Validation

The SLO implementation was validated in Prometheus.

Verified components:

- Application request counter
- Good request rate
- Total request rate
- Availability ratio
- 99.9% SLO
- 0.1% error budget
- 5-minute burn rate
- 1-hour burn rate
- 30-minute burn rate
- 6-hour burn rate
- Critical burn-rate alert
- Warning burn-rate alert
- Alertmanager integration

During healthy application operation:

5-minute burn rate = 0x

1-hour burn rate = 0x

30-minute burn rate = 0x

6-hour burn rate = 0x

Both SLO burn-rate alerts were verified as inactive.

---

## 15. SLO Design Summary

Service:

PetClinic

SLI:

HTTP request availability

Good request:

outcome="SUCCESS"

Excluded traffic:

/actuator.*

SLO:

99.9%

Error budget:

0.1%

Rate window:

5 minutes

Critical burn rate:

14.4x

Critical windows:

5 minutes + 1 hour

Warning burn rate:

6x

Warning windows:

30 minutes + 6 hours
