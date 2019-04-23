# Hashicorp Consul

Source: Youtube

Managing operational challenges due to deployment of individual discete servies.

Consul provides a service mesh capability:

## Discovery
discovery via central service registry
* services register with registry
* service can discover another service via registry

## Configuration
central key-value store

## Segmentation
connect
centrally manage who can talk to who
* service A can talk to service B (no ip)
services identified via TLS certificates
access control via proxies


# Hashicorp Consul Connect

Securing the architecture of distributed services

Three security zones:

DMZ (outside world) | App | Data zone

East-West traffic pattern -> service to service communication

Service segmentation

Service graph -> high level rules (at service level) which define which services can communicate

Connect enables native communication via an SDK

