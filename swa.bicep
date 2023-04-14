// ---------------------------------------------------------
// Parameters
@description('Required - Name of the static site')
param name string

@description('Optional - Location of resources')
param location string = resourceGroup().location

@allowed([
  'Free'
  'Standard'
])
@description('Optional - Type of static site')
param sku string = 'Free'

@description('Optional - False if config file is locked for this static web app; otherwise, true.')
param allowConfigFileUpdates bool = true

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional - Staging environment allowed/not allowed for app.')
param stagingEnvironmentPolicy string = 'Enabled'

@allowed([
  'Disabled'
  'Disabling'
  'Enabled'
  'Enabling'
])
@description('Optional - Status of enterprise grade CDN serving traffic to app.')
param enterpriseGradeCdnStatus string = 'Disabled'

@description('Optional - Build properties for the static site.')
param buildProperties object = {}

@description('Optional - Template Options for the static site.')
param templateProperties object = {}

@description('Optional - The provider that submitted the last deployment to the primary environment of the static site.')
param provider string = 'None'

@secure()
@description('Optional - The Personal Access Token for accessing the GitHub repository.')
param repositoryToken string = ''

@description('Optional - The name of the GitHub repository.')
param repositoryUrl string = ''

@description('Optional - The branch name of the GitHub repository.')
param branch string = ''

// ---------------------------------------------------------
// Resource

resource staticSite 'Microsoft.Web/staticSites@2022-03-01' = {
  name: name
  location: location
  sku:{
    name: sku
    tier: sku
  }
  properties: {
    allowConfigFileUpdates: allowConfigFileUpdates
    stagingEnvironmentPolicy: stagingEnvironmentPolicy
    enterpriseGradeCdnStatus: enterpriseGradeCdnStatus
    provider: !empty(provider) ? provider : 'None'
    branch: !empty(branch) ? branch : null
    buildProperties: !empty(buildProperties) ? buildProperties : null
    repositoryToken: !empty(repositoryToken) ? repositoryToken : null
    repositoryUrl: !empty(repositoryUrl) ? repositoryUrl : null
    templateProperties: !empty(templateProperties) ? templateProperties : null 
  }
}

// -------------------------------------------------------------------
// Outputs

@description('The name of the static site.')
output name string = staticSite.name

@description('The resource ID of the static site.')
output resourceId string = staticSite.id

@description('The URL of the static site.')
output siteUrl string = staticSite.properties.defaultHostname

@description('The resource group the static site was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = staticSite.location
