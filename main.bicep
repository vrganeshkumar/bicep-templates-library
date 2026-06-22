// main.bicep
// Composes storage, web app, and key vault modules into one environment deployment.
// Deploy with: az deployment group create --resource-group <rg> --template-file main.bicep --parameters main.parameters.json

@description('Environment name, e.g. dev, staging, prod')
param environmentName string

@description('Cost center tag for billing attribution')
param costCenter string

@description('Azure region for all resources')
param location string = resourceGroup().location

@description('Base name used to derive resource names, e.g. "contoso"')
param baseName string

@description('App Service Plan SKU - use B1 for dev, P1v3 for prod')
param appServicePlanSku string = 'B1'

module storage 'modules/storage-account.bicep' = {
  name: 'storageDeploy'
  params: {
    storageAccountName: '${baseName}${environmentName}sa'
    location: location
    environmentName: environmentName
    costCenter: costCenter
  }
}

module webApp 'modules/app-service-plan-webapp.bicep' = {
  name: 'webAppDeploy'
  params: {
    appServicePlanName: '${baseName}-${environmentName}-plan'
    webAppName: '${baseName}-${environmentName}-app'
    location: location
    skuName: appServicePlanSku
    environmentName: environmentName
    costCenter: costCenter
  }
}

module keyVault 'modules/key-vault.bicep' = {
  name: 'keyVaultDeploy'
  params: {
    keyVaultName: '${baseName}-${environmentName}-kv'
    location: location
    environmentName: environmentName
    costCenter: costCenter
  }
}

output webAppHostName string = webApp.outputs.webAppHostName
output storageEndpoint string = storage.outputs.primaryEndpoint
output keyVaultUri string = keyVault.outputs.keyVaultUri
