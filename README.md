# SDI 4213 Week 12 Infrastructure as Code

OpenTofu manages a local Help Desk lab with Nginx, PostgreSQL, and Adminer.
The exercise demonstrates provisioning, state inspection, drift detection,
reconciliation, persistent storage, a variable change, and teardown.

## Configuration

| Component | Configuration |
| --- | --- |
| OpenTofu | 1.13.9, matching `.opentofu-version` and CI |
| Docker provider | `kreuzwerker/docker` 4.6.0, pinned and locked |
| Portal | `nginx:1.30.6-alpine-slim`; initially port 8080, final demonstrated port 8088 |
| Database | `postgres:18.6-alpine`; database `helpdesk`, user `student`; no host port published |
| Adminer | `adminer:5.5.1`; host port 8081 |
| Network | `sdi4213-week12-network` |
| Persistent volume | `sdi4213-week12-postgres-data` mounted at `/var/lib/postgresql` |

PostgreSQL 18 stores data under `/var/lib/postgresql/18/docker`. The volume mount
corrects the older `/var/lib/postgresql/data` path in the starter instructions.
See the [official PostgreSQL image documentation](https://hub.docker.com/_/postgres#pgdata).

## Run

Install OpenTofu 1.13.9 and start Docker Engine. From this directory:

```bash
cp terraform.tfvars.example terraform.tfvars
chmod 600 terraform.tfvars
```

Edit `terraform.tfvars` and add your own `postgres_password`. Keep it local.
The example starts the portal at 8080; set `web_port = 8088` to use the final
demonstrated port. Adminer uses 8081. Then run:

```bash
tofu fmt -recursive
tofu init
tofu validate
tofu plan
tofu apply
tofu output
docker ps
```

Review each plan before entering `yes`; do not use `-auto-approve`.
Open the URLs printed by `tofu output`. In Adminer, select PostgreSQL and use:

- Server: `sdi4213-week12-db` (or your project's database container name)
- Username: `student`
- Password: your local `postgres_password`
- Database: `helpdesk`

To reproduce the record milestone, run this once through Adminer's SQL command page:

```sql
CREATE TABLE milestone (id integer PRIMARY KEY, note text NOT NULL);
INSERT INTO milestone (id, note) VALUES (1, 'Week 12 persistence test');
SELECT * FROM milestone;
```

## Drift and persistence

```bash
docker rm -f sdi4213-week12-db
tofu plan
tofu apply
```

Remove only the database container, retaining its named volume. The plan should
recreate that container. Reconnect through Adminer and select the `milestone`
table to verify that the original row remains.

For the variable milestone, change `web_port` from 8080 to 8088 in
`terraform.tfvars`, review `tofu plan`, and run `tofu apply`. This replaces the
web container and updates `portal_url`. Inspect state with `tofu state list`
and `tofu show`.

## Cleanup

Capture the running-state evidence before cleanup:

```bash
tofu plan -destroy
tofu destroy
docker ps -a --filter name=sdi4213-week12
docker network ls --filter name=sdi4213-week12
docker volume ls --filter name=sdi4213-week12
tofu state list
```

Destroy intentionally removes the database volume and its data. Image resources
leave OpenTofu state, but downloaded images remain cached because
`keep_locally = true`. The lab was destroyed after verification; the documented
URLs require applying the configuration again.

## Submission

- [GitHub issue](https://github.com/jakeryderv/devops-week12/issues/1)
- [Final pull request](https://github.com/jakeryderv/devops-week12/pull/2)
- [Evidence and results](evidence/README.md)
- [Reflection](docs/reflection.md)
- [Original assignment](docs/Week12_Individual_Exercise.docx)

The `IaC Checks` workflow runs formatting and validation on pull requests and
pushes to `main`. It does not deploy Docker resources.

Never commit `terraform.tfvars`, local state, saved plan files, or credentials.
Sensitive variables are masked in normal CLI output, but state and saved plans
can still contain their values. Commit `.terraform.lock.hcl` for reproducible
provider selection.
