param location string = resourceGroup().location
param env_specifier string
param env_friendly string

resource my_hp 'Microsoft.DesktopVirtualization/hostpools@2021-03-09-preview' = {
  name: '${env_specifier}-hp'
  location: location
  properties: {
    description: 'Created via Bicep template'
    hostPoolType: 'Pooled'
    customRdpProperty: 'audiocapturemode:i:1;camerastoredirect:s:*;devicestoredirect:s:*;drivestoredirect:s:*;redirectprinters:i:1;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;singlemoninwindowedmode:i:1;'
    maxSessionLimit: 1
    loadBalancerType: 'BreadthFirst'
    validationEnvironment: false
    preferredAppGroupType: 'Desktop'
    startVMOnConnect: false
  }
}

resource my_hp_DAG 'Microsoft.DesktopVirtualization/applicationgroups@2021-03-09-preview' = {
  name: '${env_specifier}-hp-DAG'
  location: location
  kind: 'Desktop'
  properties: {
    hostPoolArmPath: my_hp.id
    description: 'Desktop Application Group'
    friendlyName: 'Default Desktop'
    applicationGroupType: 'Desktop'
  }
}

resource my_ws 'Microsoft.DesktopVirtualization/workspaces@2021-03-09-preview' = {
  name: '${env_specifier}-ws'
  location: location
  properties: {
    friendlyName: '${env_friendly} Workspace'
    applicationGroupReferences: [
      my_hp_DAG.id
    ]
  }
}
