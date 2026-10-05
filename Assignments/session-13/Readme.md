# Session 13: Storage, HPA and Probes

## 1. Volumes

Data written inside a container is lost when the container is removed. A volume gives the Pod a
separate place to store data.

| | emptyDir | hostPath |
|---|---|---|
| Where | Empty folder created with the Pod | Folder on the node |
| Survives Pod deletion | No | Yes, on the same node |
| Use case | Cache, scratch files | Local testing, node level tools |

### Run emptyDir Pod

![alt text](./screenshots/img_1.png)

### Create a File

![alt text](./screenshots/img_2.png)

### Delete the Pod

The file is gone because the `emptyDir` was deleted along with the Pod.

![alt text](./screenshots/img_3.png)

## 2. PersistentVolume and PersistentVolumeClaim

- **PV** is storage available in the cluster.
- **PVC** is a request for storage. The Pod uses the PVC, not the PV.
- `Bound` means the PVC got a matching volume.
- The data outlives the Pod.

```text
Pod  ->  PVC  ->  PV  ->  Storage
```

### Create PV, PVC and Pod

![alt text](./screenshots/img_4.png)

### Test Persistent Storage

![alt text](./screenshots/img_5.png)

### Delete the Pod

The file is still there because the data lives on the PV, not in the Pod.

![alt text](./screenshots/img_6.png)

## 3. StorageClass

- A StorageClass creates PVs automatically when a PVC asks for one. This is **dynamic provisioning**.
- Minikube's default class is `standard`.
- A PVC without `storageClassName` uses the default class.

```text
PVC  ->  StorageClass  ->  PV created automatically
```

### Check StorageClass

![alt text](./screenshots/img_7.png)

### Dynamic PVC

![alt text](./screenshots/img_8.png)

## 4. Horizontal Pod Autoscaler (HPA)

- HPA adds or removes Pods based on CPU usage.
- It needs the **Metrics Server** and `resources.requests.cpu` on the container.
- Scale up is fast. Scale down waits about 5 minutes.

### Deployment and Service

![alt text](./screenshots/img_9.png)

### Metrics Server

![alt text](./screenshots/img_10.png)

### Create HPA

![alt text](./screenshots/img_11.png)

### Generate Load

![alt text](./screenshots/img_12.png)

### Stop the Load

![alt text](./screenshots/img_13.png)

## 5. Probes

A Pod can be `Running` while the app inside is broken. Probes check the app itself.

| Probe | Question | On failure |
|---|---|---|
| Startup | Has the app started? | Container restarts |
| Readiness | Can it take traffic? | Removed from Service endpoints, no restart |
| Liveness | Is it still alive? | Container restarts |

### Liveness Probe

![alt text](./screenshots/img_14.png)

### Readiness Probe

![alt text](./screenshots/img_15.png)

### Startup Probe

![alt text](./screenshots/img_16.png)

### Breaking Readiness

![alt text](./screenshots/img_17.png)

### Breaking Liveness

![alt text](./screenshots/img_18.png)

## 6. Mini Project

A web app in the `production-webapp` namespace that combines everything from this session.

| Part | Setup |
|---|---|
| Storage | PVC `web-data`, 500Mi, mounted at `/data` |
| Scaling | HPA from 2 to 5 Pods at 50% CPU |
| Health | Startup, readiness and liveness probes |

### Deployment

![alt text](./screenshots/img_19.png)

### Storage Persistence

![alt text](./screenshots/img_20.png)

### Service Verification

![alt text](./screenshots/img_21.png)

### HPA Scaling

![alt text](./screenshots/img_22.png)

## Key Learnings

- **emptyDir** dies with the Pod, **PVC** keeps data across Pods.
- **StorageClass** removes the need to create PVs by hand.
- **HPA** scales Pods on CPU load.
- **Readiness** controls traffic, **liveness** and **startup** control restarts.
