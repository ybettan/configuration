#!/bin/bash

curl observatorium-xyz-observatorium-api-gateway-observatorium.apps-crc.testing/\
api/metrics/v1/api/v1/query/?query=kube_pod_container_status_running
