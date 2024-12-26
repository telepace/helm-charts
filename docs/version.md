# Telepace Helm Charts 版本管理优化方案

### 版本控制策略优化

**定制化版本控制方式**  
Telepace 采用基于标签（Tag）的版本管理，与传统的分支式版本控制相比，操作更加简洁高效。

**核心要素**：
- **`Chart.yaml` 文件版本定义**  
  每个 Helm 图表包含一个 `Chart.yaml` 文件，用于定义图表版本信息。每次更新版本时，通过修改 `Chart.yaml` 中的 `version` 字段进行记录，例如：  
  ```yaml
  version: 0.1.13
  ```

- **自动化 CICD 流程**  
  开发者不需要手动操作分支、标签或发布，所有流程均由 CICD 系统自动处理，包括构建、测试和发布。每次提交更新代码后，CICD 管道会自动触发构建并完成相关操作。

- **版本标签命名规范**  
  发布版本后，CICD 系统会自动为其生成标签并记录至 Helm 仓库中，标签命名采用以下规范：
  1. **`v1.0.0-telepace` 格式**：主版本号、次版本号和修订版本号后附加分支标识符，适用于跨分支场景，方便排序与识别。
  2. **`telepace-v1.0.0` 格式**：分支标识符置于版本号前，便于快速区分多分支版本。

**推荐策略**：
- **单分支仓库**：建议使用 `telepace-v1.0.0` 格式，清晰标识各版本。
- **多分支场景**：建议使用 `v1.0.0-telepace` 格式，方便进行跨分支版本管理。

---

### 发布与安装流程优化

**自动发布**  
每次创建标签后，CICD 自动完成构建与发布流程。例如，发布的包 `https://github.com/telepace/helm-charts/releases/tag/telepace-server-0.1.2`，可通过以下命令下载和解压：  
```bash
tar -zxvf telepace-server-0.1.2.tgz
```

**目录结构**  
解压后的目录结构清晰直观，包含所有必要文件：  
```
telepace-server/
├── Chart.yaml
├── README.md.gotmpl
├── templates/
│   ├── deployment.yaml
│   ├── _helpers.tpl
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── NOTES.txt
│   ├── serviceaccount.yaml
│   ├── service.yaml
│   └── tests/
│       └── test-connection.yaml
└── values.yaml
```

**安装图表**  
用户可以使用 Helm 命令轻松完成安装：  
```bash
helm install telepace-server ./telepace-server
```

---

### 镜像版本管理优化

**一致性命名与版本控制**  
所有服务镜像均遵循统一的命名规范和版本管理规则，确保服务与 Helm 图表间的兼容性：

- **镜像列表**：
  - **Server 服务镜像**：  
    - `ghcr.io/telepace/analysis`  
    - `ghcr.io/telepace/collection`  

  - **Web 服务镜像**：  
    - `ghcr.io/telepace/web`  

  - **反馈采集 API 镜像**：  
    - `ghcr.io/telepace/ai_feedback_django`  

  - **Voiceflow 服务镜像**：  
    - `ghcr.io/telepace/voiceflow`  

- **版本号规则**  
  所有镜像版本均遵循 Telepace 的统一版本号规范，保证组件间版本匹配性。

---

### Web 界面与 Helm 仓库集成

CICD 系统还支持 Helm 仓库的自动部署，例如 `https://telepace.github.io/helm-charts/`。用户可以通过以下步骤快速使用 Telepace 图表：  

1. **添加 Helm 仓库**：
   ```bash
   helm repo add telepace https://telepace.github.io/helm-charts/
   ```

2. **查询可用图表**：
   ```bash
   helm search repo telepace
   ```