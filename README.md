# AKS Bootcamp

## Tools

1. [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
2. kubectl: `az aks install-cli`
3. [Lens](https://k8slens.dev/): An IDE to visually navigate Kubernetes
4. [Terraform](https://www.terraform.io/downloads.html): Automated infrastructure install
5. [Docker Desktop](https://www.docker.com/products/docker-desktop) (OPTIONAL): This lets you have a local kubernetes instance to play with

## Excercises

Prerequisite: get the access token for terraform state store account 

```bash
export ARM_ACCESS_KEY=$(az storage account keys list -g "Sandbox-base" --subscription "Transact Dev Sandbox" --account-name tcdemos --query "[?keyName=='key1'].value | [0]" -o tsv)
```

### STEP 1: Deploy an AKS cluster using Terraform

```bash
cd infrastructure/terraform-infra
terraform init
terraform apply
```

### STEP 2: Connect to the AKS cluster

```bash
az aks get-credentials -g RG-US-East2-bootcamp --admin -n AKS-US-East2-bootcamp
```

### STEP 3: Create a Namespace

```bash
kubectl create namespace myname
kubectl config set-context --current --namespace myname
```

### STEP 4: Deploy Basic Application

```bash
cd applications
kubectl apply -k whereami
```

**Connect to one of the pods**

```bash
kubectl get pods
kubectl port-forward pod/<pod-id> 8080 
```
Browse to [http://localhost:8080](http://localhost:8080)

### STEP 5: Deploy Application with External Service

**Edit the `applications/whereami/kustomize.yaml` file to uncomment the line that says `service-lb.yaml`**

```yaml
resources:
- ksa.yaml
- deployment.yaml
- configmap.yaml
- service-lb.yaml
#- service-internal.yaml
#- ingress.yaml
```

Then run

```bash
cd applications
kubectl apply -k whereami
kubectl get services -w
```

Wait for an external IP then browse to http://external-ip-from-above

### STEP 6: Deploy Application with Ingress Comtroller

**Edit the `applications/whereami/kustomize.yaml` file as below**

```yaml
resources:
- ksa.yaml
- deployment.yaml
- configmap.yaml
# service-lb.yaml
- service-internal.yaml
- ingress.yaml
```

**Edit the `applications/whereami/ingress.yaml` file to replace the host**

```yaml
- host: bootcamp.myname.io
```

Then run

```bash
cd applications
kubectl apply -k whereami
kubectl get services -w
```

**Poison your etc/hosts**

```
external-ip-from-above bootcamp.myname.io
```

Then browse to [http://bootcamp.myname.io](http://bootcamp.myname.io)

## Kubectl Cheatsheet

- `kubectl cluster-info` : Print the address of the master and cluster services
- `kubectl exec pod_name -- ls /` : Run command in an existing pod
- `kubectl get pod|service|deployment|ingress|... -o wide` : List all information about a resource with more details
- `kubectl config get-contexts` : Gets configured clusters in the kubeconfig file
- `kubectl config use-context docker-dekstop` : Sets the current-context (cluster in use) in a kubeconfig file
- `kubectl config set-context --current --namespace=namespace` : sets the default namespace

## Other Resources

1. Monitoring (See [Lab 5 here](https://azure.github.io/kube-labs/5-aks-appinsights.html#prerequisites))
