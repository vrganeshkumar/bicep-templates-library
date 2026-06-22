// modules/key-vault.bicep
// Deploys a Key Vault using RBAC authorization (not legacy access policies),
// with soft-delete and purge protection enabled.

@description('Name of the Key Vault (must be globally unique, 3-24 chars)')
param keyVaultName string

@description('Azure region for the resource')
param location string = resourceGroup().location

@description('Azure AD tenant ID')
param tenantId string = subscription().tenantId

@description('Environment tag, e.g. dev, staging, prod')
param environmentName string

@description('Cost center tag for billing attribution')
param costCenter string

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  tags: {
    Environment: environmentName
    CostCenter: costCenter
  }
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantId
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enablePurgeProtection: true
  }
}

output keyVaultId string = keyVault.id
output keyVaultUri string = keyVault.properties.vaultUri
