@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Server Farm to create.')
param serverFarmName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the second Storage Account to create.')
param storageAccount2Name string

// Virtual Network with subnet
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
          delegations: [
            {
              name: 'Microsoft.Web.serverFarms'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
    ]
  }
}

// Managed Identity
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

// Server Farm (App Service Plan)
resource serverFarm 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: serverFarmName
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
  properties: {
    reserved: false
  }
}

// Storage Account 1 - for Azure Files
resource storageAccount1 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
  }

  // File Service for Azure Files
  resource fileService 'fileServices@2025-01-01' = {
    name: 'default'

    // File Share for main storage
    resource fileShare 'shares@2025-01-01' = {
      name: 'myfileshare'
      properties: {
        shareQuota: 5120
      }
    }

    // File Share for staging
    resource stagingShare 'shares@2025-01-01' = {
      name: 'stagingshare'
      properties: {
        shareQuota: 1024
      }
    }
  }
}

// Storage Account 2 - for Azure Blob
resource storageAccount2 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccount2Name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
  }

  // Blob Service for Azure Blob
  resource blobService 'blobServices@2025-01-01' = {
    name: 'default'

    // Container for blob storage
    resource container 'containers@2025-01-01' = {
      name: 'mycontainer'
      properties: {
        publicAccess: 'None'
      }
    }
  }
}

// Outputs
@description('The resource ID of the created Virtual Network.')
output virtualNetworkResourceId string = virtualNetwork.id

@description('The resource ID of the created subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Server Farm.')
output serverFarmResourceId string = serverFarm.id

@description('The name of the first Storage Account.')
output storageAccountName string = storageAccount1.name

@description('The resource ID of the first Storage Account.')
output storageAccountResourceId string = storageAccount1.id

@description('The primary access key of the first Storage Account.')
@secure()
output storageAccountKey string = storageAccount1.listKeys().keys[0].value

@description('The name of the second Storage Account.')
output storageAccount2Name string = storageAccount2.name

@description('The resource ID of the second Storage Account.')
output storageAccount2ResourceId string = storageAccount2.id

@description('The primary access key of the second Storage Account.')
@secure()
output storageAccount2Key string = storageAccount2.listKeys().keys[0].value
