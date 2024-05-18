# Woodpecker CI server

This pack contains all you need to deploy Woodpecker CI server in Nomad. It uses Docker driver.

## Variables

- "resources" (object) - The resource to assign to the application.
- "http_service" (object) - Integrations with Nomad or Consul for service discovery.
- "grpc_service" (object) - Integrations with Nomad or Consul for service discovery.
- "region" (string) - The region where jobs will be deployed.
- "host_network" (string) - Designates the host network name to use when allocating the port.
- "constraints" (list of object) - Additional constraints to apply to the job.
- "job_name" (string) - The name to use as the job name which overrides using the pack name.
- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "environment" (map of string) - Environment variables to pass to task.
