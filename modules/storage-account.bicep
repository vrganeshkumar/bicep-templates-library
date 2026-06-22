// modules/storage-account.bicep
// Deploys a storage account with secure-by-default settings.

@description('Name of the storage account (must be globally unique, lowercase, 3-24 chars)')
param storageAccountName string

@description('Azure region for the resource')
param location string = resourceGroup().location

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
])
@description('Replication SKU')
param skuName string = 'Standard_LRS'

@description('Environment tag, e.g. dev, staging, prod')
param environmentName string

@description('Cost center tag for billing attribution')
param costCenter string

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
  tags: {
    Environment: environmentName
    CostCenter: costCenter
  }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
  }
}

output storageAccountId string = storageAccount.id
output primaryEndpoint string = storageAccount.properties.primaryEndpoints.blob
