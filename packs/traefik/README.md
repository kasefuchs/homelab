# Traefik

This pack contains all you need to deploy Traefik in Nomad. It uses Docker driver.

## Variables

- "resources" (object) - The resource to assign to the application.
- "environment" (map of string) - Environment variables to pass to task.
- "job_name" (string) - The name to use as the job name which overrides using the pack name.
- "region" (string) - The region where jobs will be deployed.
- "datacenters" (list of string) - A list of datacenters in the region which are eligible for task placement.
- "constraints" (list of object) - Additional constraints to apply to the job.