param custom_vision_training_service_name string
param custom_vision_prediction_service_name string
param location string

resource accounts_ahimgcls_name_resource 'Microsoft.CognitiveServices/accounts@2023-10-01-preview' = {
  name: custom_vision_training_service_name
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'CustomVision.Training'
  properties: {
    customSubDomainName: custom_vision_training_service_name
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource accounts_ahimgcls_Prediction_name_resource 'Microsoft.CognitiveServices/accounts@2023-10-01-preview' = {
  name: custom_vision_prediction_service_name
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'CustomVision.Prediction'
  properties: {
    customSubDomainName: custom_vision_prediction_service_name
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Enabled'
  }
}
