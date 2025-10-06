targetScope = 'subscription'

metadata name = 'Web App with Azure Storage Accounts Configuration'
metadata description = 'This instance deploys the module as Web App with azurestorageaccounts configuration to demonstrate proper usage.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-web.sites-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'wsazsto'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Note, we enforce the location due to quota restrictions in other regions (esp. east-us)
#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    serverFarmName: 'dep-${namePrefix}-sf-${serviceShort}'
    storageAccountName: 'dep${namePrefix}st${serviceShort}'
    storageAccount2Name: 'dep${namePrefix}st2${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: enforcedLocation
      kind: 'app'
      serverFarmResourceId: nestedDependencies.outputs.serverFarmResourceId
      diagnosticSettings: [
        {
          name: 'customSetting'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      configs: [
        {
          name: 'azurestorageaccounts'
          properties: {
            mystorage1: {
              accountName: nestedDependencies.outputs.storageAccountName
              accessKey: nestedDependencies.outputs.storageAccountKey
              type: 'AzureFiles'
              shareName: 'myfileshare'
              mountPath: '/mounts/storage1'
              protocol: 'Smb'
            }
            // Second storage mount - Azure Blob example
            mystorage2: {
              accountName: nestedDependencies.outputs.storageAccount2Name
              accessKey: nestedDependencies.outputs.storageAccount2Key
              type: 'AzureBlob'
              shareName: 'mycontainer'
              mountPath: '/mounts/storage2'
              protocol: 'Http'
            }
          }
        }
      ]
      slots: [
        {
          name: 'staging'
          configs: [
            {
              name: 'azurestorageaccounts'
              properties: {
                // Slot-specific storage mount example
                stagingstorage: {
                  accountName: nestedDependencies.outputs.storageAccountName
                  accessKey: nestedDependencies.outputs.storageAccountKey
                  type: 'AzureFiles'
                  shareName: 'stagingshare'
                  mountPath: '/mounts/staging'
                  protocol: 'Smb'
                }
              }
            }
          ]
        }
      ]
    }
  }
]
