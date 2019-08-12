local conprof = (import 'conprof/conprof.libsonnet');

conprof {
  conprof+:: {
    config+:: {
      namespace: 'observatorium',

      rawconfig:
        {
          scrape_configs: [{
            job_name: 'conprof',
            kubernetes_sd_configs: [{
              namespaces: { names: $.conprof.config.namespaces },
              role: 'pod',
            }],
            relabel_configs: [
              {
                action: 'keep',
                regex: 'thanos.*',
                source_labels: ['__meta_kubernetes_pod_name'],
              },
              {
                action: 'keep',
                regex: 'http',
                source_labels: ['__meta_kubernetes_pod_container_port_name'],
              },
            ],
            scrape_interval: '1m',
            scrape_timeout: '1m',
          }],
        },
    },
  },
}
