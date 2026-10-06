# Session 14: Kubernetes Troubleshooting

Troubleshooting follows a fixed order instead of random commands:

```text
get  ->  describe  ->  events  ->  logs  ->  exec  ->  test  ->  fix  ->  verify
```

## 1. kubectl get

Shows **what** is happening right now. The first columns to read are `STATUS`, `READY` and
`RESTARTS`.

### Pods and Wide Output

![alt text](./Screenshots/img_1.png)

### Other Resources

![alt text](./Screenshots/img_2.png)

### Watching Changes

![alt text](./Screenshots/img_3.png)

## 2. kubectl describe

Shows **why** it is happening. The most useful parts are the container `State`, `Conditions` and the
`Events` at the bottom.

![alt text](./Screenshots/img_4.png)

## 3. kubectl logs

Shows what the application itself printed to stdout and stderr.

- `-f` follows new lines live.
- `--previous` shows logs of the last crashed container.
- `-c` picks one container in a multi container Pod.

![alt text](./Screenshots/img_5.png)

## 4. kubectl exec

Runs commands inside a running container, to test the app from inside. It does not help when the
container keeps crashing, since there is nothing stable to enter.

### Shell Inside the Container

![alt text](./Screenshots/img_6.png)

### Single Commands Without a Shell

![alt text](./Screenshots/img_7.png)

## 5. Events

Events are the activity log of what Kubernetes tried to do, such as scheduling, pulling the image and
starting the container. They expire after about 1 hour.

### Listing Events

![alt text](./Screenshots/img_8.png)

### Events in describe and kubectl events

![alt text](./Screenshots/img_9.png)

## 6. CrashLoopBackOff

The container starts, crashes, and Kubernetes keeps restarting it with a growing wait. It is a symptom,
so the real reason comes from the logs. Here the command ends with `exit 1`.

### Broken Pod

![alt text](./Screenshots/img_10.png)

### Logs

![alt text](./Screenshots/img_11.png)

### Fixed Pod

![alt text](./Screenshots/img_12.png)

## 7. ImagePullBackOff

Kubernetes cannot download the image. Here the tag `nginx:this-image-does-not-exist` does not exist.
The reason appears in the `Events` of `describe`.

### Broken Pod

![alt text](./Screenshots/img_13.png)

### Fixed Pod

![alt text](./Screenshots/img_14.png)

## 8. Pending Pods

The scheduler could not place the Pod on any node. Here the `nodeSelector` asks for a node that does
not exist. `Events` show `FailedScheduling` with the reason.

### Broken Pod

![alt text](./Screenshots/img_15.png)

### Fixed Pod

![alt text](./Screenshots/img_16.png)

## 9. Service and DNS

A Service finds Pods through its **selector**. If the selector does not match the Pod labels, the
Service has no endpoints and traffic fails even though the Pods are healthy.

```text
Pod labels  ->  Service selector  ->  Endpoints  ->  Service IP  ->  DNS name
```

### Deployment and Service

The provided `service.yaml` has the selector `app: web-ahsgdf`, so the endpoints came out empty.

![alt text](./Screenshots/img_17.png)

### Finding and Fixing the Selector

The Pods have `app: web`. After changing the selector to `app: web` and applying again, the endpoints
show the Pod IPs.

![alt text](./Screenshots/img_18.png)

### DNS and HTTP Test

Service DNS name format: `service-name.namespace.svc.cluster.local`.

![alt text](./Screenshots/img_19.png)

### Broken Service

![alt text](./Screenshots/img_20.png)

### CoreDNS

![alt text](./Screenshots/img_21.png)

## 10. Mini Project

### Deploy the Application

![alt text](./Screenshots/img_22.png)

### Check the Application

![alt text](./Screenshots/img_23.png)

### Check the Service and Endpoints

![alt text](./Screenshots/img_24.png)

### Broken Pod

![alt text](./Screenshots/img_25.png)

**Q1. What is the Pod status?**

`ErrImagePull`, then `ImagePullBackOff`.

**Q2. What is the actual error?**

Kubernetes failed to pull the image because the tag was not found in the registry.

**Q3. Which command helped find the reason?**

`kubectl describe pod project-broken-pod`, in the `Events` section.

**Q4. What is wrong with the image?**

The tag `nginx:this-tag-does-not-exist` does not exist.

**Q5. How would it be fixed?**

Change the image to a valid tag such as `nginx:1.27`, delete the Pod and apply it again.

### Service Selector Problem

![alt text](./Screenshots/img_26.png)

### Root Cause and Fix

![alt text](./Screenshots/img_27.png)

### Troubleshooting Table

| Problem | What I Saw | Command I Used | Root Cause | Fix |
|---|---|---|---|---|
| Broken Pod | `CrashLoopBackOff`, restarts going up | `kubectl logs --previous` | Command ends with `exit 1` | Use the fixed command |
| Service Problem | Endpoints `<none>` | `kubectl get endpoints`, `--show-labels` | Selector `wrong-app` does not match `troubleshooting-app` | Correct the selector |
| Image Problem | `ImagePullBackOff` | `kubectl describe pod` | Image tag does not exist | Use a valid tag |

### README Questions

1. **What does `kubectl get` tell us?** The current status of resources, such as `STATUS`, `READY`
   and `RESTARTS`.
2. **Difference between `get` and `describe`?** `get` is a one line summary, `describe` gives full
   details including Events.
3. **Why use `kubectl logs`?** To see what the application itself printed, usually the error behind a
   crash.
4. **When to use `kubectl exec`?** When the container is running and something needs to be tested from
   inside, like `curl localhost`.
5. **What does `CrashLoopBackOff` mean?** The container keeps starting and crashing, and Kubernetes
   waits longer before each restart.
6. **What does `ImagePullBackOff` mean?** Kubernetes cannot pull the image, due to a wrong name or
   tag, registry auth or network issues.
7. **Why can a Pod stay `Pending`?** No node fits it: not enough CPU or memory, a wrong node selector,
   taints, affinity or an unbound PVC.
8. **Why can a Service have no endpoints?** Its selector matches no Pod labels, or the matching Pods
   are not ready.
9. **Selector and labels relationship?** The Service sends traffic only to Pods whose labels match its
   selector.
10. **What is Kubernetes DNS?** CoreDNS gives each Service a name like
    `web-service.default.svc.cluster.local`, so Pods can reach it by name instead of IP.
