# Lavalink

This pack contains all you need to deploy Lavalink in Nomad. It uses Java driver.

## Variables

- "constraints" (list of object) - Additional constraints to apply to the job.
- "service" (object) - Specifies integrations with Nomad or Consul for service discovery.
- "artifact_source" (string) - Lavalink artifact source.
- "job_name" (string) - The name to use as the job name which overrides using the pack name.
- "region" (string) - The region where jobs will be deployed.
- "host_network" (string) - Designates the host network name to use when allocating the port.
- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "resources" (object) - The resource to assign to the application.
- "config" (string) - Lavalink configuration.
