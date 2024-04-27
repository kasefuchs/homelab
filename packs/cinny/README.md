# Cinny

This pack contains all you need to deploy Cinny in Nomad. It uses Docker driver.

## Variables

- "home_path" (string) - Home path where the extracted Cinny artifact will be served.
- "config_path" (string) - Path where the Cinny configuration file will be stored.
- "resources" (object) - Resources to assign to the task.
- "config" (object) - Cinny configuration to use.
- "job_name" (string) - The name to use as the job name which overrides using the pack name.
- "host_network" (string) - The host network to which bind services.
- "artifact" (string) - URL of compiled Cinny artifact.
- "service" (object) - Integrations with Nomad or Consul for service discovery.
- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "count" (number) - The number of application instances to deploy.
- "constraints" (list of object) - Additional constraints to apply to the job.
