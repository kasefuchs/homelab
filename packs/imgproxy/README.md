# imgproxy

This pack contains all you need to deploy imgproxy in Nomad. It uses Docker driver.

## Variables

- "job_name" (string) - The name to use as the job name which overrides using the pack name.
- "region" (string) - The region where jobs will be deployed.
- "host_network" (string) - Designates the host network name to use when allocating the port.
- "environment" (map of string) - Environment variables to pass to task.
- "count" (number) - The number of application instances to deploy.
- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "constraints" (list of object) - Additional constraints to apply to the job.
- "resources" (object) - The resource to assign to the application.
- "service" (object) - Integrations with Nomad or Consul for service discovery.
