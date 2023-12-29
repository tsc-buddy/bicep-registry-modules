# <Add module name> `[Microsoft.Web/hostingEnvironments]`

<Add description>

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/web/hosting-environment:<version>`.

- [Defaults](#example-1-defaults)
- [Waf-Aligned](#example-2-waf-aligned)

### Example 1: _Defaults_

<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/res/web/hosting-environment:<version>' = {
  name: '${uniqueString(deployment().name, location)}-test-whedef'
  params: {
    name: 'whedef001'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "whedef001"
    }
  }
}
```

</details>
<p>

### Example 2: _Waf-Aligned_

<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/res/web/hosting-environment:<version>' = {
  name: '${uniqueString(deployment().name, location)}-test-whewaf'
  params: {
    name: 'whewaf001'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "whewaf001"
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the resource to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |

### Parameter: `name`

Name of the resource to create.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`


## Outputs

| Output | Type |
| :-- | :-- |

## Cross-referenced modules

_None_
