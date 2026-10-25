# Cluster Config

## Nomad, Consul, Vault, Traefik config files for bedroom dc

## Nomad inspection tooling

[`.dsh/nomad-tool`](.dsh/nomad-tool/README.md) is a read-only DSH plugin that adds the
`nomad_status` and `nomad_logs` tools, plus a `nomadq` CLI. Every request is a GET against
an allowlist of Nomad read endpoints, so it cannot change cluster state.
