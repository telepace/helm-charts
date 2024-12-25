#!/bin/bash

# 生成 Redis 配置
kubectl create secret generic redis-credentials \
  --from-literal=redis-password=redispassword

# 生成 PostgreSQL 配置
kubectl create secret generic postgres-credentials \
  --from-literal=postgres-username=feedback_user \
  --from-literal=postgres-password=feedback_password \
  --from-literal=postgres-database=feedback_db
