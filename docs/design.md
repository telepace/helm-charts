# 设计方案


## 整体架构

1.	代码仓库：托管在 GitHub 上，包含 Web 和 Server 应用的源代码及 Kubernetes 配置。
2.	GitHub Actions：负责构建、测试、打包 Docker 镜像，并推送到 GitHub Container Registry。
3.	GitHub Container Registry：存储构建好的 Docker 镜像。
4.	Helm：管理 Kubernetes 应用的部署，通过 Helm Charts 简化配置。
5.	Kong：作为 API 网关，处理流量路由、安全认证、限流等功能。
6.	Argo CD：持续监控 Git 仓库，自动将变更应用到 GKE 集群，实现 GitOps 流程。


## 开始前准备

1.	GKE 集群：已按照前述步骤创建并配置好。（或者其他 Kubernetes 集群）
2.	GitHub 仓库：包含 Web 和 Server 应用的源代码，并配置好 GitHub Actions 和 GitHub Container Registry。
3.	Helm 安装：确保本地和集群中已安装 Helm。
4.	Argo CD 安装：将在后续步骤中详细介绍。


## 开发测试环境

+ 开发 / 测试环境：常常倾向于把所有中间件与微服务放在同一个 Umbrella Chart 中，方便“一键部署”，大幅减少人工干预。
+ 生产环境：会根据实际需要将数据层、网关层、监控层等进行独立运维，保持较高弹性和稳定性（数据库容器升级策略不同，监控组件自成体系）。Umbrella Chart 只负责管理核心应用微服务，或仅做逻辑上的聚合。
+ 建议建立多套 values-<env>.yaml 文件，用于 dev/staging/prod 环境的差异化配置。例如资源配额、镜像 tag、数据库连接地址等。
+ 在 CI/CD 流程里，借助 helm lint、helm unittest 等操作做静态测试，最后再 helm install/upgrade 到测试环境进行自动化测试和回归。


## 监控

1. Prometheus + Grafana + Loki + Alertmanager + (Jaeger) 的组合，是当前云原生比较常见的一套解决方案。
2. 在 Helm 层面，主要通过 ServiceMonitor / PodMonitor、日志 sidecar / 注解、Tracing SDK 等来集成。
3. 建议为每个微服务添加健康检查端点（/healthz、/readyz）以及 /metrics 暴露端点，以协助自动化运维。


## 安全

1. 在生产环境，更要注重敏感信息的安全：数据库密码、API Key、服务账号等。可用 SealedSecrets、External Secrets Operator 等方式来管理。
2. 在 Helm 层面，可以通过 Helm Secrets 来管理敏感信息。
3. 对日志/监控数据做存储持久化，并配置必要的保留策略，避免占用过多资源。


## 镜像准备

**server 的两个镜像：**

```bash
ghcr.io/telepace/analysis
ghcr.io/telepace/collection
```

**web 的镜像：**

```bash
ghcr.io/telepace/web
```

**feedback-collection-api 的镜像：**

```bash
ghcr.io/telepace/ai_feedback_django
```

**voiceflow 的镜像：**

```bash
ghcr.io/telepace/voiceflow
```

后面的版本号参考 telepace 的版本号设计规则。[telepace 版本号设计规则](https://github.com/telepace/telepace/blob/main/docs/version.md)


## 部署

1. 准备集群：Kubernetes 节点、网络、存储 Class、Ingress / LB 等基础设施就绪。
2. 安装CRD（如 Prometheus Operator 需要）及 helm repo 注册。
3. 进入 Umbrella Chart 目录，执行 helm dependency update，拉取并整理所有子 Chart。
4. 执行 helm install/upgrade 到指定命名空间（或多个命名空间），传入所需的 values-{env}.yaml 覆盖配置信息。
5. 查看 Pods/Svc，确认各微服务、中间件启动正常；在 Grafana 面板检查指标、Loki 中检查日志等。
6. 后续升级，只需要变更 Umbrella Chart 或子 Chart 版本，然后 helm upgrade 即可统一滚动更新；有问题可以 helm rollback。