# Description: This script is used to deploy the Bicep template using Azure CLI in PowerShell

####################################################################################################
################################ Install PowerShell Modules ########################################
####################################################################################################


####################################################################################################
######################################### Functions ################################################
####################################################################################################

# Function to check if a parameter is not empty
function IsNotEmpty($param) {
    return -not [string]::IsNullOrEmpty($param)
}

####################################################################################################
####################################### DEBUG HELPER ###############################################
####################################################################################################



####################################################################################################
###################################### Compose inputs ##############################################
####################################################################################################

$azureSubscriptionId = '113da23a-9e56-45a6-bc3f-d83f97a57a22'
$location = 'northeurope'
$templateFilePath = "$PSScriptRoot/../deploy/main.bicep"

####################################################################################################
######################################### Authenticate #############################################
####################################################################################################

# Check if already logged in
$loggedIn = az account show --output json | ConvertFrom-Json -ErrorAction SilentlyContinue

if (-not $loggedIn) {
    # If not logged in, perform the login
    az login --scope https://management.core.windows.net//.default
}
else {
    Write-Output ">-> Already logged in as $($loggedIn.name)"
}

az account set --subscription $azureSubscriptionId


####################################################################################################
################################ Check for existing resources ######################################
####################################################################################################



####################################################################################################
######################################### Validate #################################################
####################################################################################################

$parametersArray = @(
    ('subscriptionId', $azureSubscriptionId),
    ('baseName', $baseName),
    ('location', $location)
)

Write-Output "_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
# Print parametersArray to debug console
Write-Output ">-> Parameters:"
$parametersArray | ForEach-Object { Write-Output "$($_[0]): $($_[1])" }

# Filter out parameters with empty values
$filteredParameters = $parametersArray | Where-Object { IsNotEmpty $_[1] }

$parametersString = $filteredParameters | ForEach-Object { "$($_[0])=$($_[1])" }

Write-Output "_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"

# Print the parameters string to debug console after curating
Write-Output ">-> Parameters:"
$parametersString | ForEach-Object { Write-Output $_ }

Write-Output "_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"

####################################################################################################
######################################### Deploy ###################################################
####################################################################################################

# Deploy the Bicep template using Azure CLI in PowerShell
$result = az deployment sub create `
        --template-file $templateFilePath `
        --location $location `
        --parameters $parametersString `
        --debug
