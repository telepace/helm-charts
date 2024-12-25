# GKE 快速上手


## GKE 收费
## GKE 收费概览

Google Kubernetes Engine (GKE) 提供多种收费模式，主要包括标准版和企业版。以下是各个模式的详细信息：

### 标准版
- **集群管理费**：每个集群每小时 $0.10。
- **计算资源费用**：根据使用的 Compute Engine 实例收费，按秒计费，最低 1 分钟起价。

### 企业版
- **集群管理费**：每个集群每小时 $0.10。
- **计算资源费用**：按每个 vCPU 每小时 $0.00822 计费，提供更高级的功能和支持。

### Autopilot 模式
- **固定费用**：每个集群每小时 $0.10，此外还需支付工作负载的费用。
- **资源预配**：根据工作负载的需求自动预配资源，确保高效利用。

### 免费层级
- 每月提供 $74.40 的免费赠金，适用于可用区级集群和 Autopilot 集群。

### 其他费用
- **延长支持期**：每个集群每小时 $0.50。
- **多集群 Ingress**：根据后端 pod 的数量收费，每个后端 pod 每月 $3。

如需详细了解 GKE 的收费模式和计算方法，请参考 Google Cloud 的官方文档。



### GKE 操作模式

- Autopilot 模式（推荐）：GKE 管理底层基础架构，例如节点配置、自动扩缩、自动升级、基准安全配置和基准网络配置。
- Standard 模式：您负责管理底层基础架构，包括配置各个节点。
