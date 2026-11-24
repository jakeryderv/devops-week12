# Week 12 Reflection

## 1. Declarative and imperative infrastructure

Declarative management describes the result that should exist, such as a
PostgreSQL container connected to a network with a named volume. OpenTofu works
out the actions needed to reach that result. Imperative management specifies
individual actions, such as running `docker rm -f` to remove a container. In this
lab, the configuration described the desired stack, while the manual removal
created a difference that OpenTofu could repair.

## 2. The role of state

State connects resource names in the configuration to real Docker objects and
their IDs. The starter had three managed resources, and the full stack had eight.
When the database container was removed, OpenTofu refreshed its view of Docker
and planned to recreate the missing resource. State helps it manage existing
objects instead of creating a new stack every time. It stays out of Git because
it is local operational data and may contain secrets.

## 3. Why the PostgreSQL data survived

The database files lived in the named Docker volume, independently of the
container. Only the database container was removed during the drift test. The
replacement container mounted the same volume, and the row with ID 1 and note
`Week 12 persistence test` was still present. The container IDs changed, which
confirmed that the row survived recreation. PostgreSQL 18 required mounting
`/var/lib/postgresql` so its actual data directory was inside the named volume.

## 4. Sensitive variables and state security

Marking the password variable sensitive hid its value in normal plan and apply
output. It did not encrypt the password or keep it out of local state. Someone
who can read the state could still recover credentials. The password was supplied
through ignored `terraform.tfvars`, and neither that file nor state was committed.
Screenshots also needed to exclude credentials.

## 5. The port-change plan

Changing `web_port` from 8080 to 8088 made OpenTofu plan to replace the web
container: one resource to add, zero to change in place, and one to destroy.
The port attribute was marked as forcing replacement, and `portal_url` changed
to `http://localhost:8088`. Reviewing the plan showed that the database and its
volume would remain untouched and that the portal would have a brief interruption.
