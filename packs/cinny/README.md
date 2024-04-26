# Cinny

This pack contains all you need to deploy Cinny in Nomad. It uses Docker driver.

## Variables

- "config" (object) - Specifies cinny configuration to use.
- "host_network" (string) - The host network to which bind services.
- "artifact" (string) - Specifies url of compiled Cinny artifact.
- "service" (object) - Specifies integrations with Nomad or Consul for service discovery.
- "home_path" (string) - Specifies the home path where the extracted Cinny artifact will be served.
- "config_path" (string) - Specifies the path where the Cinny configuration file will be stored.
- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "job_name" (string) - The name to use as the job name which overrides using the pack name.
- "count" (number) - The number of application instances to deploy.
- "constraints" (list of object) - Additional constraints to apply to the job.
- "resources" (object) - The resource to assign to the task.
