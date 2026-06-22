// modules/app-service-plan-webapp.bicep
// Deploys an App Service Plan + Web App. SKU is parameterized so the same
// module deploys a cheap Dev tier and a production-grade Prod tier.

@description('Name of the App Service Plan')
param appServicePlanName string

@description('Name of the Web App (must be globally unique)')
param webAppName string

@description('Azure region for the resources')
param location string = resourceGroup().location

@description('SKU for the App Service Plan, e.g. B1 for dev, P1v3 for prod')
param skuName string = 'B1'

@description('Environment tag, e.g. dev, staging, prod')
param environmentName string

@description('Cost center tag for billing attribution')
param costCenter string

@description('Runtime stack, e.g. DOTNETCORE|8.0 or NODE|20-lts')
param linuxFxVersion string = 'DOTNETCORE|8.0'

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appServicePlanName
  location: location
  tags: {
    Environment: environmentName
    CostCenter: costCenter
  }
  sku: {
    name: skuName
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: webAppName
  location: location
  tags: {
    Environment: environmentName
    CostCenter: costCenter
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
    }
  }
}

output webAppHostName string = webApp.properties.defaultHostName
output webAppId string = webApp.id
