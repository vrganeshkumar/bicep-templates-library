# Bicep Templates Library

Reusable, parameterized Bicep modules built and maintained by V R Ganesh Kumar — Azure DevOps & Cloud Cost Consultant.

These modules are written the way I deploy infrastructure for clients: parameterized (no hardcoded names/regions), tagged for cost tracking, and composed together via a single `main.bicep` rather than copy-pasted per environment.

## What's inside

| Module | Deploys |
|---|---|
| `modules/storage-account.bicep` | A storage account with secure defaults (TLS 1.2 minimum, HTTPS-only, no public blob access) |
| `modules/app-service-plan-webapp.bicep` | An App Service Plan + Web App, with the plan SKU as a parameter so you can right-size per environment |
| `modules/key-vault.bicep` | A Key Vault with RBAC authorization (not legacy access policies) and soft-delete enabled |
| `main.bicep` | Composes the three modules above into one deployable environment (e.g. Dev/Staging/Prod) |

## Why this structure

- **One module, many environments.** The same `app-service-plan-webapp.bicep` deploys a B1 SKU in Dev and a P1v3 in Prod — just change the parameter file, not the template.
- **Cost tags from day one.** Every resource gets `Environment` and `CostCenter` tags, so a cost audit (see my Azure Cost Audit service) can actually attribute spend instead of guessing.
- **Secure by default.** Public access is off by default everywhere; you opt in explicitly if a resource genuinely needs to be public.

## Using these templates

```bash
az deployment group create \
  --resource-group YOUR_RESOURCE_GROUP \
  --template-file main.bicep \
  --parameters main.parameters.json
```

Run `az deployment group what-if` first with the same arguments to preview changes before applying them.

---

**Need Bicep/IaC set up for your Azure environment, or a cost audit of what's already running?** Reach out at vrganesh936@gmail.com.
