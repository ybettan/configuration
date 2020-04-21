#!/bin/bash

oc create namespace minio
oc create namespace observatorium

oc apply -f environments/dev/manifests/
oc expose svc/observatorium-xyz-observatorium-api-gateway -n observatorium

observatoriu_svc_ip=`oc get svc/observatorium-xyz-observatorium-api-gateway -n observatorium \
    | tr -s " " | tail -1 | cut -d" " -f3`

echo "
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-monitoring-config
  namespace: openshift-monitoring
data:
  config.yaml: |
    prometheusK8s:
      remoteWrite:
        - url: "http://$observatoriu_svc_ip:8080/api/metrics/v1/write"
          writeRelabelConfigs:
          - sourceLabels: [__name__]
            replacement: seal18_OS_cluster # this is the name of the cluster
            targetLabel: cluster
          tlsConfig:
            insecureSkipVerify: true
" | oc apply -f -

oc scale --replicas=1 statefulset --all -n openshift-monitoring; \
    oc scale --replicas=1 deployment --all -n openshift-monitoring
