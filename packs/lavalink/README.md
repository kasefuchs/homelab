# Lavalink

This pack contains all you need to deploy Lavalink in Nomad. It uses Docker driver.

## Variables

- `job_name` (string "") - The name to use as the job name which overrides using the pack name.
- `host_network` (string "tailscale") - The host network to which bind service.
- `datacenters` (list(string) ["*"]) - A list of datacenters in the region which are eligible for
  task placement.
- `constraints` (list(object)) - Constraints to apply to the entire job.
- `service_tags` (list(string)) - A list of tags to assign to service.
- `service_name` (string "lavalink") - Service name to use.
- `resources` (object) - The resources to assign to the Lavalink task.
- `artifact_source` (string) - Link to download Lavalink server JAR from.
- `env` (object) - Environment variables to use with service.
- `lavalink_config_file` (string) - Path to local template of Lva
