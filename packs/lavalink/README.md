# Lavalink

This pack contains all you need to deploy Lavalink in Nomad. It uses Java driver.

## Variables

- "job_name" (string) - The name to use as the job name which overrides using the pack name.
- "constraints" (list of object) - Additional constraints to apply to the job.
- "service_tags" (list of string) - Tags to use for service.
- "service_name" (string) - Name for service.
- "env" (map of string) - Environment variables for task.
- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "resources" (object) - The resource to assign to the lavalink service task.
- "artifact_source" (string) - Lavalink artifact source.
- "lavalink_config_file" (string) - Lavalink configuration file template.
- "host_network" (string) - The host network to which bind service.
