# Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations `[Microsoft.ContainerService/managedClusters/maintenanceConfigurations]`

This module deploys an Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ContainerService/managedClusters/maintenanceConfigurations` | [2023-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2023-10-01/managedClusters/maintenanceConfigurations) |
| `Microsoft.ContainerService/managedClusters/maintenanceConfigurations` | [2024-03-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2024-03-02-preview/managedClusters/maintenanceConfigurations) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clusterMaintenanceWindow`](#parameter-clustermaintenancewindow) | object | Maintenance window for the cluster maintenance configuration. |
| [`nodeMaintenanceWindow`](#parameter-nodemaintenancewindow) | object | Maintenance window for the node maintenance configuration. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedClusterName`](#parameter-managedclustername) | string | The name of the parent managed cluster. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clusterMaintenanceName`](#parameter-clustermaintenancename) | string | Name of the maintenance configuration. |
| [`nodeMaintenanceName`](#parameter-nodemaintenancename) | string | Name of the maintenance configuration. |

### Parameter: `clusterMaintenanceWindow`

Maintenance window for the cluster maintenance configuration.

- Required: No
- Type: object

### Parameter: `nodeMaintenanceWindow`

Maintenance window for the node maintenance configuration.

- Required: No
- Type: object

### Parameter: `managedClusterName`

The name of the parent managed cluster. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `clusterMaintenanceName`

Name of the maintenance configuration.

- Required: No
- Type: string
- Default: `'aksManagedAutoUpgradeSchedule'`

### Parameter: `nodeMaintenanceName`

Name of the maintenance configuration.

- Required: No
- Type: string
- Default: `'aksManagedNodeOSUpgradeSchedule'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `clusterMaintenanceName` | string | The name of the maintenance configuration. |
| `clusterMaintenanceResourceId` | string | The resource ID of the maintenance configuration. |
| `nodeMaintenanceName` | string | The name of the maintenance configuration. |
| `nodeMaintenanceResourceId` | string | The resource ID of the maintenance configuration. |
| `resourceGroupName` | string | The resource group the agent pool was deployed into. |
