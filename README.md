# 项目部署与修改指南

本指南将帮助您完成项目的完整部署，并指导如何进行代码和配置的修改。请按照以下步骤操作。

## 前提条件

在开始之前，请确保您已经具备以下条件：

1. **Google Cloud 账户**：用于创建和管理 GKE 集群。
2. **GitHub 账户**：用于访问代码仓库和配置 GitHub Actions。
3. **本地开发环境**：
   - 已安装 [Helm](https://helm.sh/docs/intro/install/)
   - 已安装 [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
   - 已安装 [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## 克隆仓库

首先，克隆项目代码仓库到本地：

```bash
git clone https://github.com/telepace/helm-charts.git
cd helm-charts
```

## 设置 Google Kubernetes Engine (GKE) 集群

### 创建 GKE 集群

参考 [docs/gcloud.md](docs/gcloud.md) 获取详细的 GKE 快速上手指南。以下是创建 GKE 集群的基本步骤：

```bash
gcloud container clusters create your-cluster-name \
    --zone your-zone \
    --num-nodes=3
```

### 配置 `kubectl`

将 `kubectl` 配置为连接到新创建的 GKE 集群：

```bash
gcloud container clusters get-credentials your-cluster-name --zone your-zone
```

## 安装 Helm 图表

项目中使用 Helm 管理 Kubernetes 应用的部署。以下是安装和更新 Helm 图表的步骤。

### 初始化 Helm 仓库

确保您已经添加了所需的 Helm 仓库：

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### 部署应用

运行安装脚本以部署所有服务：

```bash
./scripts/install.sh
```

该脚本将遍历 `charts` 目录下的所有 Helm 图表，进行安装和配置。

### 手动部署单个服务

如果需要单独部署某个服务，可以使用以下命令：

```bash
helm install [release-name] ./charts/[chart-name] --namespace [namespace] --create-namespace
```

例如，部署 `web` 服务：

```bash
helm install web-release ./charts/web --namespace web --create-namespace
```

## 配置 GitHub Actions

项目使用 GitHub Actions 进行持续集成和持续部署（CI/CD）。以下是配置步骤：

1. **创建 GitHub Secrets**：
   - `GCP_PROJECT_ID`：您的 Google Cloud 项目 ID。
   - `GCP_SA_KEY`：包含 GCP 服务账户密钥的 JSON 字符串。
   - `REGISTRY`：GitHub Container Registry 的地址，例如 `ghcr.io/your-username`.

2. **配置 Argo CD**：
   - Argo CD 将自动监控 Git 仓库中的变更，并应用到 GKE 集群。
   - 请参考 [docs/design.md](docs/design.md) 中关于 Argo CD 的部分进行详细配置。

## 修改配置

### 更新 Helm Values

每个服务的配置信息存储在对应的 `values.yaml` 文件中。您可以根据需求修改这些配置。

例如，修改 `web` 服务的副本数量和资源限制：

```yaml
# charts/web/values.yaml

replicaCount: 3

resources:
  limits:
    cpu: 500m
    memory: 256Mi
  requests:
    cpu: 250m
    memory: 128Mi
```

修改完成后，应用更新：

```bash
helm upgrade web-release ./charts/web --namespace web
```

### 添加新服务

如果需要添加新的服务，请按照以下步骤操作：

1. **创建 Helm 图表**：

   ```bash
   helm create charts/new-service
   ```

2. **配置 Chart.yaml**：

   编辑 `charts/new-service/Chart.yaml`，填写服务名称和描述。

3. **设置 Values**：

   修改 `charts/new-service/values.yaml` 以配置服务的默认值。

4. **编写模板**：

   在 `charts/new-service/templates` 目录下添加 Kubernetes 资源定义模板，例如 `deployment.yaml`、`service.yaml` 等。

5. **部署新服务**：

   ```bash
   helm install new-service-release ./charts/new-service --namespace new-service --create-namespace
   ```

## 验证部署

### 查看部署状态

使用 `kubectl` 命令查看各个服务的部署状态：

```bash
kubectl get all -n web
kubectl get all -n backend
# 针对其他命名空间执行类似命令
```

### 访问应用

根据 `ingress` 或 `service` 的配置，访问相应的 URL 或 IP 地址。例如，如果 `ingress` 已启用：

```bash
http://your-domain.com
```

## 日志与监控

项目集成了 Kong 作为 API 网关和 Prometheus 进行监控，您可以通过以下方式访问日志和监控数据：

- **Kong 管理界面**：访问 `http://kong-admin.your-domain.com`
- **Prometheus**：访问 `http://prometheus.your-domain.com`

## 更新和升级

### 更新代码仓库

拉取最新的代码更改：

```bash
git pull origin main
```

### 更新 Helm 图表

如果 Helm 图表有更新，运行以下命令进行升级：

```bash
helm upgrade [release-name] ./charts/[chart-name] --namespace [namespace]
```

例如，升级 `analysis` 服务：

```bash
helm upgrade analysis-release ./charts/analysis --namespace analysis
```

### 更新 GitHub Actions

确保 `.github/workflows` 目录下的工作流配置文件是最新的。若有更新，请提交并推送更改，GitHub Actions 将自动执行相应任务。

## 故障排除

### 查看 Pod 日志

使用 `kubectl` 查看特定 Pod 的日志：

```bash
kubectl logs [pod-name] -n [namespace]
```

### 进入 Pod 容器

进入运行中的容器以进行调试：

```bash
kubectl exec -it [pod-name] -n [namespace] -- /bin/bash
```

### 检查资源

确保集群资源充足，避免因资源不足导致的部署失败。

```bash
kubectl describe nodes
kubectl top pods -n [namespace]
```

## 贡献指南

欢迎提交 Pull Request 以贡献代码和改进配置。请遵循 [CODEOWNERS](.github/CODEOWNERS) 文件中的代码所有权规则。

## 许可证

本项目采用 [Apache License 2.0](LICENSE) 许可证。请参阅 [LICENSE](LICENSE) 文件获取详细信息。
