# nonprod-eks Cluster Deployment

This directory contains **Infrastructure as Code (CloudFormation)** and **Helm charts** to:

✅ Deploy a private **EKS Cluster** in AWS  
✅ Create **3 Managed Node Groups**  
✅ Enable **Amazon VPC CNI, CoreDNS, EBS-CSI, and Kube-Proxy add-ins**  
✅ Set up **IAM Role for AWS Load Balancer Controller (using IRSA)**  
✅ Deploy **AWS Load Balancer Controller** and **Datadog Daemonset** with `helm`

---

## 📁 Contents:

```
infra/
 ├─ eks-cluster.yaml                 CloudFormation stack to create EKS, node groups, roles, and add-ins
 ├─ launch-template-userdata.sh     Userdata script to tag nodes at launch
 └─ values/
     ├─ aws-load-balancer-controller-values.yaml
     └─ datadog-values.yaml
```

---

## 🔹 Prerequisites:

✅ AWS CLI configured with credentials:
```shell
aws sts get-caller-identity
```

✅ `kubectl` installed:
```shell
kubectl version --client
```

✅ `helm` installed:
```shell
helm version
```

✅ An existing VPC and at least 2 private subnets.

---

## 🔹 Deployment:

### 1️⃣ Deploy CloudFormation stack:

```shell
aws cloudformation deploy \
  --template-file infra/eks-cluster.yaml \
  --stack-name nonprod-eks \
  --parameter-overrides ClusterName=nonprod-eks VpcId=vpc-xxxxx SubnetIds=subnet-abc,subnet-def \
  --capabilities CAPABILITY_IAM
```

➥ Wait for stack to complete (about 10-15 minutes).

---

### 2️⃣ Update `kubeconfig` to connect:

```shell
aws eks --region us-west-2 update-kubeconfig --name nonprod-eks
```

➥ Validate:

```shell
kubectl get nodes
```

---

### 3️⃣ Install AWS Load Balancer Controller:

```shell
helm repo add eks https://aws.github.io/eks-charts
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system -f infra/values/aws-load-balancer-controller-values.yaml
```

---

### 4️⃣ Install Datadog Daemonset:

```shell
helm repo add datadog https://helm.datadoghq.com
helm install datadog-agent datadog/datadog -f infra/values/datadog-values.yaml
```

---

## 🔹 Cleanup:

To destroy all resources:

```shell
aws cloudformation delete-stack --stack-name nonprod-eks
```

---

## 🔹 Notes:

✅ The **EKS Cluster endpoint is private**; you'll need **network access (such as a bastion or VPN)** to connect directly.

✅ The **IAM role for AWS LB controller** is created by CloudFormation (using OIDC).

✅ The **node groups** use **Amazon Linux 2 EKS-optimized AMI**, and **kubelet** is initialized with custom `--node-labels`.

---

## 🔹 Additional:

➥ To view pods:

```shell
kubectl get pods -A
```

➥ To view services:

```shell
kubectl get services -A
```

---

🚀 If you’d like, we can:

- Provide a convenient `Makefile`
- Provide a `deploy.sh` script to streamline
- Provide a complete Git repository you can clone directly

Just let me know by typing:

```
give me a convenient script
```
and I'll furnish it immediately.

