# Session 20: Monitoring, Observability and GitOps

## 1. Monitoring vs Observability

| Monitoring | Observability |
|---|---|
| Watches known problems with predefined checks | Helps understand **unknown** problems from the outside |
| Answers "is it working?" | Answers "why is it not working?" |
| Dashboards and alerts | Explore metrics, logs and traces together |

## 2. Metrics, Logs and Traces

| Signal | What it is | Example |
|---|---|---|
| Metrics | Numbers over time | CPU 80%, 200 requests/s |
| Logs | Timestamped event messages | `Health check OK` |
| Traces | The path of one request across services | API → auth → database |

### Demo App on a kind Cluster

![alt text](./Screenshots/img_1.png)

### Logs and Describe

![alt text](./Screenshots/img_2.png)

### Clean Up

![alt text](./Screenshots/img_3.png)

## 3. Prometheus

Prometheus **pulls** (scrapes) metrics from targets every few seconds, stores them as time series and
answers queries in **PromQL**. `up = 1` means a target is reachable.

### Start Prometheus

![alt text](./Screenshots/img_4.png)

### Querying `up`

![alt text](./Screenshots/img_5.png)

### Stop

![alt text](./Screenshots/img_6.png)

## 4. Grafana

Grafana does not store metrics. It reads them from a data source such as Prometheus and shows them
as dashboards. Inside Docker Compose, Grafana reaches Prometheus by its service name
`http://prometheus:9090`.

### Start Prometheus and Grafana

![alt text](./Screenshots/img_7.png)

### Prometheus Data Source

![alt text](./Screenshots/img_8.png)

### Dashboard

![alt text](./Screenshots/img_9.png)

### Stop

![alt text](./Screenshots/img_10.png)

## 5. Introduction to GitOps

| Traditional | GitOps |
|---|---|
| Engineer runs `kubectl apply` | A controller applies what is in Git |
| Cluster can drift from any record | Git is the desired state, drift is corrected |
| Hard to audit or roll back | Every change is a reviewed, revertible commit |

![alt text](./Screenshots/img_11.png)

## 6. Git as Source of Truth

Changing the desired state means changing a file in Git and committing it, not editing the cluster.

### Creating the Repository

![alt text](./Screenshots/img_12.png)

### Changing the Desired State

![alt text](./Screenshots/img_13.png)

## 7. Argo CD

Argo CD runs inside the cluster, watches a Git repository and keeps the cluster in sync with it.
`prune` removes what was deleted from Git, `selfHeal` undoes manual changes.

```text
git push -> GitHub -> Argo CD detects change -> Kubernetes updated
```

The manifests were pushed to **https://github.com/Harshita-008/gitops-demo** (folder `07-argocd/app`).

### Cluster

![alt text](./Screenshots/img_14.png)

### Installing Argo CD

![alt text](./Screenshots/img_15a.png)

![alt text](./Screenshots/img_15b.png)

### Argo CD UI

![alt text](./Screenshots/img_16.png)

### Registering the Application

![alt text](./Screenshots/img_17.png)

### Synced Application

![alt text](./Screenshots/img_18.png)

### The Running App

![alt text](./Screenshots/img_19.png)

### Scaling to 2 by Git Push

![alt text](./Screenshots/img_20.png)

### Scaling to 3 by Git Push

![alt text](./Screenshots/img_21.png)

### Clean Up

![alt text](./Screenshots/img_22.png)

## 8. Mini Project

Namespace, Deployment (2 replicas) and Service deployed only through Argo CD from
**https://github.com/Harshita-008/gitops-demo** (folder `08-mini-project/app`).

```text
Git (desired state) -> Argo CD (reconciler) -> Kubernetes (actual state)
```

### Cluster and Argo CD

![alt text](./Screenshots/img_23.png)

### Application Synced

![alt text](./Screenshots/img_24.png)

### Git Change: 3 Replicas

![alt text](./Screenshots/img_25.png)

### Self-Healing

A manual `kubectl scale` to 1 replica was reverted by Argo CD back to the 3 replicas stored in Git.

![alt text](./Screenshots/img_26.png)

### Observing the System

![alt text](./Screenshots/img_27.png)

### Clean Up

![alt text](./Screenshots/img_28.png)

## Key Learnings

- **Metrics, logs and traces** together make a system observable.
- **Prometheus** collects metrics, **Grafana** visualises them.
- In **GitOps**, Git is the single source of truth for the cluster.
- **Argo CD** syncs Git to Kubernetes and self-heals manual drift.
