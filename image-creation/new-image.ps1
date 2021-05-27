$imageResourceGroup = 'rg-images'
$location = 'eastus'
$templateFilePath = './image-template.json'
$imageTemplateName = "se-wvd-" + (Get-Date -Format yyyyMMddHHmm)

New-AzResourceGroupDeployment -ResourceGroupName $imageResourceGroup -TemplateFile $templateFilePath -api-version "2020-02-14" -imageTemplateName $imageTemplateName -svclocation $location
Start-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $imageTemplateName  -NoWait