# Week 12 Evidence

The lab was executed on November 23, 2026 (America/Chicago). Terminal images
capture actual command output, with lengthy plans reduced to their resource
actions and totals. Browser images capture the running portal and Adminer.

Repository: <https://github.com/jakeryderv/devops-week12>

Final pull request: <https://github.com/jakeryderv/devops-week12/pull/2>

| Milestone | Screenshot | Observed result |
| --- | --- | --- |
| 1. Tools | [01-tools.png](01-tools.png) | OpenTofu 1.13.9 and Docker client/server 29.10.0 |
| 2. Initialization | [02-init.png](02-init.png) | Provider 4.6.0 installed and initialization succeeded |
| 3. Initial plan | [03-validate-plan.png](03-validate-plan.png) | Valid configuration; 3 additions, no changes or deletions |
| 4. Starter apply | [04-first-apply.png](04-first-apply.png) | Nginx portal visible after apply |
| 5. Starter state | [05-state-list.png](05-state-list.png) | Network, Nginx image, and web container in state |
| 6. Full-stack plan | [06-full-stack-plan.png](06-full-stack-plan.png) | 5 additions; password masked; named volume mount configured |
| 7. Running stack | [07-full-stack-running.png](07-full-stack-running.png), [Adminer](07-adminer.png) | Three running containers, Adminer HTTP 200, database ready, successful Adminer login |
| 8. Database record | [08-database-record.png](08-database-record.png) | Table and row created through Adminer; ID 1, Week 12 persistence test |
| 9. Drift | [09-drift-detected.png](09-drift-detected.png) | Container removed, volume retained; plan recreates only the database container |
| 10. Reconciliation | [10-reconciled-persistent.png](10-reconciled-persistent.png), [Adminer row](10-adminer-persistent.png) | Different container ID, same named volume, original row remains |
| 11. Variable change | [11-variable-change.png](11-variable-change.png), [portal](11-portal-8088.png) | Web container replaced for 8080 to 8088; new URL returns HTTP 200 |
| 12. Teardown | [12-destroy.png](12-destroy.png) | 8 resources destroyed; no lab containers, network, volume, or managed state resources remain |
| 13. Pull request | [13-github-pr.png](13-github-pr.png) | Final PR with passing IaC Checks |

## Verification details

The full stack contained eight managed resources. After the port change,
`tofu plan -detailed-exitcode` returned 0 with "No changes. Your infrastructure
matches the configuration." Each apply and the final destroy used interactive
approval after plan review; `-auto-approve` was not used.

The persistence test changed the database container ID from
`1934cdf57884a751629b48a0e77c77e3ded8fff57d5e6fd8b14f65be6d2e16ea` to
`bc9073e530c1f237201602d65dff535fafd54018ed459c9b397fc89d2ccdf3c2`.
Both the SQL query and the reloaded Adminer table showed the original row.

PostgreSQL 18 uses `/var/lib/postgresql/18/docker`. The named volume was mounted
at `/var/lib/postgresql`, correcting the older path in the starter hints.
The final destroy removed the data volume intentionally. Downloaded Docker
images remain cached because the image resources specify `keep_locally = true`.
