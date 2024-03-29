[CmdletBinding()]
param (
    $imageResourceGroup = 'rg-images',
    $location = 'eastus',
    $templateFilePath = './windows11-image-template.json',
    $imageTemplateName = "se-avd-win11-" + (Get-Date -Format yyyyMMddHHmm),
    $sigId
)

# New-AzResourceGroupDeployment -ResourceGroupName $imageResourceGroup -TemplateFile $templateFilePath -api-version "2020-02-14" -imageTemplateName $imageTemplateName -svclocation $location
$params = @{
    imageTemplateName = $imageTemplateName
    svclocation = $location
}

# if ($sigId) {
#     $params = @{
#         imageTemplateName = $imageTemplateName
#         svclocation = $location
#         sigId = $sigId
#     }
# } else {

# }

New-AzResourceGroupDeployment -ResourceGroupName $imageResourceGroup -TemplateFile $templateFilePath -TemplateParameterObject $params

sleep 60

az image builder run --name $imageTemplateName --resource-group $imageResourceGroup --no-wait
# Start-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $imageTemplateName  -NoWait
