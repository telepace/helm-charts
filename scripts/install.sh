#!/bin/bash

# 安装中间件
helm install redis ./charts/middlewares/redis -f ../configs/redis-values.yaml
helm install postgres ./charts/middlewares/postgres -f ../configs/postgres-values.yaml
helm install minio ./charts/middlewares/minio -f ../configs/minio-values.yaml
helm install kong ./charts/middlewares/kong -f ../configs/kong-values.yaml
helm install prometheus ./charts/middlewares/prometheus -f ../configs/prometheus-values.yaml
helm install alertmanager ./charts/middlewares/alertmanager -f ../configs/alertmanager-values.yaml

# 安装业务服务
helm install feedback-collection-api ./charts/services/feedback-collection-api
helm install analysis ./charts/services/analysis
helm install collection ./charts/services/collection
helm install voiceflow ./charts/services/voiceflow
helm install web ./charts/services/web