[CmdletBinding()]
param (
    $imageResourceGroup = 'rg-images',
    $location = 'eastus',
    $templateFilePath = './image-creation/image-template.json',
    $imageTemplateName = "se-wvd-" + (Get-Date -Format yyyyMMddHHmm)     
)

# New-AzResourceGroupDeployment -ResourceGroupName $imageResourceGroup -TemplateFile $templateFilePath -api-version "2020-02-14" -imageTemplateName $imageTemplateName -svclocation $location
$params = @{
    imageTemplateName = $imageTemplateName
    svclocation = $location
}
New-AzResourceGroupDeployment -ResourceGroupName $imageResourceGroup -TemplateFile $templateFilePath -TemplateParameterObject $params

az image builder run --name $imageTemplateName --resource-group $imageResourceGroup --no-wait
# Start-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $imageTemplateName  -NoWait
