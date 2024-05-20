# Cinny

This pack contains all you need to deploy Cinny in Nomad. It uses Docker driver.

## Variables

- "host_network" (string) - The host network to which bind services.
- "artifact_source" (string) - URL of compiled Cinny artifact.
- "config_path" (string) - Path where the Cinny configuration file will be stored.
- "home_path" (string) - Home path where the extracted Cinny artifact will be served.
- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "job_name" (string) - The name to use as the job name which overrides using the pack name.
- "count" (number) - The number of application instances to deploy.
- "constraints" (list of object) - Additional constraints to apply to the job.
- "service" (object) - Integrations with Nomad or Consul for service discovery.
- "resources" (object) - Resources to assign to the task.
- "config" (string) - Cinny configuration JSON.
