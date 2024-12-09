# Kubernetes Horizontal Pod Autoscaler (HPA) Demo

This repository contains a script and configuration files to demonstrate the **Horizontal Pod Autoscaler (HPA)** in Kubernetes. The demo covers deploying an application, simulating load, and observing autoscaling in action.

## 📖 Overview

The demo showcases two methods to configure HPA:
1. **Option 1**: Using the `kubectl autoscale` command (quick setup for CPU-based scaling).
2. **Option 2**: Using a YAML manifest for advanced configurations.

The demo includes:
- Deploying an Nginx application.
- Simulating load to trigger autoscaling.
- Monitoring and validating HPA behavior (scaling up and scaling down).

## 📂 Files

| File                              | Description                                           |
|-----------------------------------|-------------------------------------------------------|
| `nginx-app-deployment.yaml`       | Deploys the Nginx application and its pods.          |
| `nginx-app-service-nodeport.yaml` | Exposes the Nginx app via a NodePort service.        |
| `nginx-app-hpa.yaml`              | YAML manifest for HPA configuration (Option 2).      |
| `LoadTest.ps1`                    | PowerShell script to simulate load on the Nginx app. |

## 🚀 Prerequisites

Before running this demo, ensure the following:
- **Kubernetes Cluster**: A running cluster with access to its `kubeconfig`.
- **Metrics Server**: Installed and configured to provide resource metrics for HPA.
- **Kubectl**: Installed and configured to interact with the cluster.
- **PowerShell**: Installed to run the load test script.
- **Node Public IP**: Ensure your cluster nodes have a public IP for accessing the Nginx service.

## 🛠️ Setup

### Clone the Repository
```powershell
git clone https://github.com/nexa-lab/k8s-hpa-demo.git
cd k8s-hpa-demo
```

# Kubernetes HPA Demo Walkthrough

This demo showcases how to set up and test Horizontal Pod Autoscaling (HPA) in a Kubernetes cluster using both `kubectl` and YAML manifests.

## 📂 Files

| File                              | Description                                           |
|-----------------------------------|-------------------------------------------------------|
| `nginx-app-deployment.yaml`       | Deploys the Nginx application and its pods.           |
| `nginx-app-service-nodeport.yaml` | Exposes the Nginx app via a NodePort service.         |
| `nginx-app-hpa.yaml`              | YAML manifest for HPA configuration (Option 2).       |
| `LoadTest.ps1`                    | PowerShell script to simulate load on the Nginx app.  |

## 📋 Steps

### Step 1: Deploy the Nginx Application
1. Set the **kubeconfig** environment variable to use the demo Kubernetes cluster configuration file:
   ```powershell
   $env:KUBECONFIG = ".\k8s-demo-kubeconfig.yaml"
   ```

2. Get the public IPs of the nodes in the cluster (useful for accessing the NodePort service):
   ```powershell
   kubectl get nodes -o wide
   ```

3. Check for currently running pods in the cluster (there should be none initially):
   ```powershell
   kubectl get pods
   ```

4. Deploy the Nginx application and expose it using a NodePort service:
   ```powershell
   kubectl apply -f ./nginx-app-deployment.yaml
   kubectl apply -f ./nginx-app-service-nodeport.yaml
   ```

5. Verify that the Nginx pods are running and monitor their status in real time:
   ```powershell
   kubectl get pods
   kubectl get pods -w
   ```

6. Access the Nginx application using the public IP of the node and NodePort from a web browser:
   ```powershell
   Invoke-WebRequest -Uri "http://<NODE_PUBLIC_IP>:30000/"
   ```

### Step 2: Set Up HPA

#### Option 1: Using `kubectl autoscale`
1. Configure Horizontal Pod Autoscaler (HPA) using `kubectl`:
   ```powershell
   kubectl autoscale deployment nginx-deployment --cpu-percent=2 --min=1 --max=10 --name=nginx-hpa
   ```

2. Monitor the HPA:
   ```powershell
   kubectl get hpa -w
   ```

3. Run the load test again to observe scaling behavior:
   ```powershell
   .\LoadTest.ps1 -targetUrl "http://<NODE_PUBLIC_IP>:30000/" -requests 1000
   ```

4. Check the number of replicas to confirm scaling is working as expected. Verify the number of replicas is increasing during high load.
   
5. Stop the load test. The HPA doesn't scale down immediately after the load drops; it waits for a stabilization window (default: 5 minutes) to ensure the low load is consistent.

6. Delete the HPA:
   ```powershell
   kubectl delete hpa nginx-hpa
   ```

7. Restore to initial state:
   ```powershell
   kubectl delete --all deployments
   kubectl apply -f ./nginx-app-deployment.yaml
   ```

#### Option 2: Using a YAML Manifest
1. Apply the HPA configuration using the YAML manifest:
   ```powershell
   kubectl apply -f ./nginx-app-hpa.yaml
   ```

2. Monitor the HPA:
   ```powershell
   kubectl get hpa -w
   ```

3. Run the load test to observe scaling up of pods:
   ```powershell
   .\LoadTest.ps1 -targetUrl "http://<NODE_PUBLIC_IP>:30000/" -requests 1000
   ```

5. Verify the number of replicas is increasing during high load.
   ```powershell
   kubectl get pods -w
   ```

6. Stop the load test and observe the pods scaling down when load decreases.

7. Delete the HPA:
   ```powershell
   kubectl delete -f ./nginx-app-hpa.yaml
   ```

8. Restore to initial state:
   ```powershell
   kubectl delete --all deployments
   kubectl apply -f ./nginx-app-deployment.yaml
   ```

### Step 3: Simulate Load
1. Simulate traffic load on the Nginx application using a load test script:
   ```powershell
   .\LoadTest.ps1 -targetUrl "http://<NODE_PUBLIC_IP>:30000/" -requests 1000
   ```

2. Observe the pods scaling up as HPA adjusts to handle the load:
   ```powershell
   kubectl get pods -w
   ```

3. Stop the load test and verify pods scale down after a stabilization period.

### Step 4: Cleanup
Delete all resources:
```bash
kubectl delete -f ./nginx-app-deployment.yaml
kubectl delete -f ./nginx-app-service-nodeport.yaml
kubectl delete -f ./nginx-app-hpa.yaml
```

---

## 🤔 Notes

- Ensure the **metrics server** is functioning; otherwise, HPA won't work.
- Option 1 (`kubectl autoscale`) supports only basic configurations and is ideal for quick setups.
- Option 2 (YAML) allows advanced scaling policies, multiple metrics, and version control.

## 📎 Resources

- [Kubernetes Documentation: Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
- [Metrics Server Installation Guide](https://github.com/kubernetes-sigs/metrics-server)
- [PowerShell Documentation](https://learn.microsoft.com/en-us/powershell/)

## 📞 Contact Us

If you'd like to discuss how this solution can benefit your organization, feel free to [Contact Nexalab](https://nexalab.io/contact-us/).

## 📝 License

This repository is licensed under the MIT License. See [LICENSE](./LICENSE) for details.

   