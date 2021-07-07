@description('Existing VNET that contains the domain controller')
param existingVNETName string

@description('Existing subnet that contains the domain controller')
param existingSubnetName string

@description('Unique public DNS prefix for the deployment. The fqdn will look something like \'<dnsname>.westus.cloudapp.azure.com\'. Up to 62 chars, digits or dashes, lowercase, should start with a letter: must conform to \'^[a-z][a-z0-9-]{1,61}[a-z0-9]$\'.')
param dnsLabelPrefix string

param hostPool string

@description('The size of the virtual machines')
param vmSize string = 'Standard_A2'

@description('The FQDN of the AD domain')
param domainToJoin string

@description('Username of the account on the domain')
param domainUsername string

@description('Password of the account on the domain')
@secure()
param domainPassword string

@description('Password of the account on the domain')
@secure()
param registrationInfoToken string

@description('Specifies an organizational unit (OU) for the domain account. Enter the full distinguished name of the OU in quotation marks. Example: "OU=testOU; DC=domain; DC=Domain; DC=com"')
param ouPath string = ''

@description('Set of bit flags that define the join options. Default value of 3 is a combination of NETSETUP_JOIN_DOMAIN (0x00000001) & NETSETUP_ACCT_CREATE (0x00000002) i.e. will join the domain and create the account on the domain. For more information see https://msdn.microsoft.com/en-us/library/aa392154(v=vs.85).aspx')
param domainJoinOptions int = 3

@description('The name of the administrator of the new VM and the domain. Exclusion list: \'admin\',\'administrator')
param vmAdminUsername string

@description('The password for the administrator account of the new VM and the domain')
@secure()
param vmAdminPassword string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the Shared Image Gallery.')
param galleryName string

@description('Name of the Image Definition.')
param galleryImageDefinitionName string

@description('Name of the Image Version - should follow <MajorVersion>.<MinorVersion>.<Patch>.')
param galleryImageVersionName string

var nicName_var = '${dnsLabelPrefix}Nic'
var networkSecurityGroupName_var = 'nsg-${dnsLabelPrefix}'
var subnetId = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks/subnets', existingVNETName, existingSubnetName)

resource nicName 'Microsoft.Network/networkInterfaces@2020-08-01' = {
  name: nicName_var
  location: location
  properties: {
    networkSecurityGroup: {
      id: networkSecurityGroupName.id
    }
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
  }
}

resource networkSecurityGroupName 'Microsoft.Network/networkSecurityGroups@2019-08-01' = {
  name: networkSecurityGroupName_var
  location: resourceGroup().location
  properties: {
    securityRules: []
  }
}

resource dnsLabelPrefix_resource 'Microsoft.Compute/virtualMachines@2019-07-01' = {
  name: dnsLabelPrefix
  location: 'eastus'
  zones: [
    '1'
  ]
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        id: resourceId('Microsoft.Compute/galleries/images/versions', galleryName, galleryImageDefinitionName, galleryImageVersionName)
      }
      osDisk: {
        osType: 'Windows'
        name: '${dnsLabelPrefix}_OsDisk'
        createOption: 'FromImage'
        caching: 'ReadWrite'
      }
      dataDisks: []
    }
    osProfile: {
      computerName: dnsLabelPrefix
      adminUsername: vmAdminUsername
      adminPassword: vmAdminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicName.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
         enabled: true
      }
    }
    licenseType: 'Windows_Client'
  }
}

resource dnsLabelPrefix_joindomain 'Microsoft.Compute/virtualMachines/extensions@2015-06-15' = {
  name: '${dnsLabelPrefix_resource.name}/joindomain'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: {
      Name: domainToJoin
      OUPath: ouPath
      User: '${domainToJoin}\\${domainUsername}'
      Restart: 'true'
      Options: domainJoinOptions
    }
    protectedSettings: {
      Password: domainPassword
    }
  }
}

resource dnsLabelPrefix_dscextension 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  name: '${dnsLabelPrefix_resource.name}/dscextension'
  location: 'eastus'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.73'
    settings: {
      modulesUrl: 'https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1-25-2021.zip'
      configurationFunction: 'Configuration.ps1\\AddSessionHost'
      properties: {
        hostPoolName: hostPool
        registrationInfoToken: registrationInfoToken
        aadJoin: false
      }
    }
    protectedSettings: {}
  }
}
