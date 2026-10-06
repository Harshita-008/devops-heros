# Session 15: Helm

Helm is the package manager for Kubernetes. One chart is written once and deployed to any environment
by passing different values.

| Term | Meaning |
|---|---|
| Chart | Packaged Kubernetes templates (the recipe) |
| Release | A running instance of a chart in the cluster |
| Values | Variables passed into the chart |

Helm 3 and later have no Tiller. Helm runs client only and stores release state as Secrets.

## 1. What is Helm

### Helm Version and Releases

![alt text](./Screenshots/img_1.png)

### Installing a Public Chart

![alt text](./Screenshots/img_2.png)

### Checking and Removing the Release

![alt text](./Screenshots/img_3.png)

## 2. Helm Charts

- `helm create` generates a full working chart skeleton.
- `helm template` renders the YAML locally without deploying. Useful for debugging.
- `helm uninstall` removes every resource the release created.

### Creating a Chart

![alt text](./Screenshots/img_4.png)

### Rendering Without Deploying

![alt text](./Screenshots/img_5.png)

### Install, List and Uninstall

![alt text](./Screenshots/img_6.png)

## 3. Chart Structure

```text
simple-chart/
  Chart.yaml      chart metadata
  values.yaml     default values
  templates/      Kubernetes YAML with {{ }} variables
```

`{{ .Release.Name }}` becomes the name given at install, and `{{ .Values.x }}` reads from
`values.yaml`.

### Rendering the Chart

![alt text](./Screenshots/img_7.png)

### Installing the Chart

![alt text](./Screenshots/img_8.png)

## 4. Chart.yaml

| Field | Meaning |
|---|---|
| `apiVersion: v2` | Required for Helm 3 and later |
| `version` | Version of the chart itself, changes when chart files change |
| `appVersion` | Version of the app being deployed, usually the image tag |
| `type` | `application` (deployable) or `library` (shared templates) |

![alt text](./Screenshots/img_9.png)

## 5. values.yaml

`values.yaml` holds the defaults. They can be overridden at install time.

```text
values.yaml  <  -f values-prod.yaml  <  --set key=value   (--set wins)
```

- `-f` files suit environment configs and stay in Git.
- `--set` is for quick one off changes.

### Overriding at Install Time

![alt text](./Screenshots/img_10.png)

### Checking Rendered Values

![alt text](./Screenshots/img_11.png)

## 6. Templates

Templates are Kubernetes YAML with Go template variables. `{{- if }}` ... `{{- end }}` skips a block
when the value is false, for example the Service when `service.enabled: false`.

![alt text](./Screenshots/img_12.png)

## 7. Install and Upgrade

Every install or upgrade creates a new **revision**, which is what makes rollback possible.

| Command | Behaviour |
|---|---|
| `helm install` | Fails if the release already exists |
| `helm upgrade` | Fails if the release does not exist |
| `helm upgrade --install` | Installs if new, upgrades if it exists. Safest for CI/CD |

### Install

![alt text](./Screenshots/img_13.png)

### Upgrade to 3 Replicas

![alt text](./Screenshots/img_14.png)

### Upgrade with --install

![alt text](./Screenshots/img_15.png)

## 8. Rollback

- `helm history` lists all revisions.
- `helm rollback <release> N` returns to revision N and creates a new revision, so history is kept.
- `--atomic` rolls back automatically if the upgrade does not become healthy in time. In Helm 4 it is
  renamed to `--rollback-on-failure`.

### Broken Upgrade

![alt text](./Screenshots/img_16.png)

### Rollback to Revision 1

![alt text](./Screenshots/img_17.png)

### Automatic Rollback with --atomic

![alt text](./Screenshots/img_18.png)

## 9. Deploying an Application

A guestbook chart with a Deployment, a NodePort Service and a ConfigMap, taken through the full
lifecycle.

```text
lint  ->  template  ->  install  ->  upgrade  ->  history  ->  rollback  ->  uninstall
```

### Lint and Render

![alt text](./Screenshots/img_19.png)

### Install and Verify

![alt text](./Screenshots/img_20.png)

### Upgrade and History

![alt text](./Screenshots/img_21.png)

### Rollback and Clean Up

![alt text](./Screenshots/img_22.png)

## 10. Mini Project: Notes App

A `notes-chart` with dev defaults in `values.yaml` (1 replica, `nginx:1.24`) and production values in
`values-prod.yaml` (3 replicas, `nginx:1.25`).

### Lint and Render

![alt text](./Screenshots/img_23.png)

### Install (Development)

![alt text](./Screenshots/img_24.png)

### Upgrade to Production Values

![alt text](./Screenshots/img_25.png)

### Bad Upgrade

![alt text](./Screenshots/img_26.png)

### Rollback to Revision 2

![alt text](./Screenshots/img_27.png)

### Clean Up

![alt text](./Screenshots/img_28.png)

## Key Learnings

- A **chart** is written once, and **values** change it per environment.
- `helm template` and `helm lint` catch mistakes before anything is deployed.
- Every install, upgrade and rollback is a numbered **revision**.
- A bad release is undone with one `helm rollback` command.
