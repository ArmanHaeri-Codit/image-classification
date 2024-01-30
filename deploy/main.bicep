/*******************************************************************************/
/********************************** Scope **************************************/
/*******************************************************************************/

targetScope = 'subscription'

/*******************************************************************************/
/********************************* Parameters **********************************/
/*******************************************************************************/

// subscription parameters
param subscriptionId string
param location string = 'northeurope'

// general parameters
param baseName string = 'image-classification'
param shortBaseName string = 'img-cls'
param randomizedSuffix string = substring(uniqueString(subscriptionId, baseName, location), 0, 5)

param separator string = '-'
param resourceGroupNameAlias string = 'rg'

// resource group parameters
param resourceGroupName string = '${resourceGroupNameAlias}${separator}${baseName}'

// services
param customVisionServiceName string = '${shortBaseName}${separator}${randomizedSuffix}'
param customVisionTrainingServiceName string = '${customVisionServiceName}${separator}train'
param customVisionPredictionServiceName string = '${customVisionServiceName}${separator}pred'

// tags
param costCenter string = 'AI-ML'
param environment string = 'DEV'



/*******************************************************************************/
/********************************* Resources ***********************************/
/*******************************************************************************/

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: location
  tags: {
    CostCenter: costCenter
    Environment: environment
    Project: baseName
  }
}

// Custom Vision Service Module
module customVisionService './modules/custom-vision.bicep' = {
  name: customVisionServiceName
  scope: resourceGroup
  params: {
    custom_vision_training_service_name: customVisionTrainingServiceName
    custom_vision_prediction_service_name: customVisionPredictionServiceName
    location: location
  }
}
