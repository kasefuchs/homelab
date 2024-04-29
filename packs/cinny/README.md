# Cinny

This pack contains all you need to deploy Cinny in Nomad. It uses Docker driver.

## Variables

- "config_path" (string) - Path where the Cinny configuration file will be stored.
- "resources" (object) - Resources to assign to the task.
- "host_network" (string) - The host network to which bind services.
- "count" (number) - The number of application instances to deploy.
- "constraints" (list of object) - Additional constraints to apply to the job.
- "artifact" (string) - URL of compiled Cinny artifact.
- "homeserver_list" (list of string) - List of homeservers.
- "default_homeserver_index" (number) - Index of default homeserver.
- "allow_custom_homeservers" (bool) - Allow third party homeservers.
- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "service" (object) - Integrations with Nomad or Consul for service discovery.
- "job_name" (string) - The name to use as the job name which overrides using the pack name.
- "home_path" (string) - Home path where the extracted Cinny artifact will be served.
