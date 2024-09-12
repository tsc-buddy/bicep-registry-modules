metadata name = 'Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations'
metadata description = 'This module deploys an Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Maintenance window for the cluster maintenance configuration.')
param clusterMaintenanceWindow object?

@description('Required. Maintenance window for the node maintenance configuration.')
param nodeMaintenanceWindow object?

@description('Conditional. The name of the parent managed cluster. Required if the template is used in a standalone deployment.')
param managedClusterName string

@description('Optional. Name of the maintenance configuration.')
param clusterMaintenanceName string = 'aksManagedAutoUpgradeSchedule'

@description('Optional. Name of the maintenance configuration.')
param nodeMaintenanceName string = 'aksManagedNodeOSUpgradeSchedule'

resource managedCluster 'Microsoft.ContainerService/managedClusters@2024-03-02-preview' existing = {
  name: managedClusterName
}

resource aksManagedAutoUpgradeSchedule 'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2023-10-01' = {
  name: clusterMaintenanceName
  parent: managedCluster
  properties: {
    maintenanceWindow: clusterMaintenanceWindow
  }
}

resource aksManagedNodeOSUpgradeSchedule 'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2024-03-02-preview' = {
  parent: managedCluster
  name: nodeMaintenanceName
  properties: {
    maintenanceWindow: nodeMaintenanceWindow
  }
}

@description('The name of the maintenance configuration.')
output name string = aksManagedAutoUpgradeSchedule.name

@description('The name of the maintenance configuration.')
output nodeMaintenanceName string = aksManagedNodeOSUpgradeSchedule.name

@description('The resource ID of the cluster maintenance configuration.')
output resourceId string = aksManagedAutoUpgradeSchedule.id

@description('The resource ID of the node maintenance configuration.')
output nodeMaintenanceResourceId string = aksManagedNodeOSUpgradeSchedule.id

@description('The resource group the agent pool was deployed into.')
output resourceGroupName string = resourceGroup().name
