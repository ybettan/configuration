local list = import 'telemeter/lib/list.libsonnet';

(import '../kubernetes/conprof.libsonnet') + {
  conprof+:: {
    config+:: {
      namespace: '${NAMESPACE}',
    },
  },
} + {
  local conprof = super.conprof,

  conprof+:: {
    template+:
      local objects = {
        ['conprof-' + name]: conprof[name]
        for name in std.objectFields(conprof)
      };

      list.asList('conprof', objects, [
        {
          name: 'NAMESPACE',
          value: 'telemeter',
        },
        {
          name: 'CONPROF_IMAGE',
          value: 'quay.io/conprof/conprof:v0.1.0-dev',
        },
      ]),
  },
}
