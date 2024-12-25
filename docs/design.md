# 设计方案


## 整体架构

1.	代码仓库：托管在 GitHub 上，包含 Web 和 Server 应用的源代码及 Kubernetes 配置。
2.	GitHub Actions：负责构建、测试、打包 Docker 镜像，并推送到 GitHub Container Registry。
3.	GitHub Container Registry：存储构建好的 Docker 镜像。
4.	Helm：管理 Kubernetes 应用的部署，通过 Helm Charts 简化配置。
5.	Kong：作为 API 网关，处理流量路由、安全认证、限流等功能。
6.	Argo CD：持续监控 Git 仓库，自动将变更应用到 GKE 集群，实现 GitOps 流程。


## 

