#decide the language
$Language = "en"


#decide the root item on which the script will run
#$ItemPath = "master:/sitecore/content/BLG/Website/Home/insights/"
#$items = Get-ChildItem -Path $Targetpath -recurse -Language $Language | Where-Object {$_.TemplateName -eq 'Insight Article' -or $_.TemplateName -eq 'Insight Podcast' -or $_.TemplateName -eq 'Insight Presentation' -or $_.TemplateName -eq 'Insight Publication' -or $_.TemplateName -eq 'Insight Upcoming Event' -or $_.TemplateName -eq 'Insight Video' -or $_.TemplateName -eq 'Insight Thought Leadership'}
#$DataSource = "/sitecore/content/BLG/Website/Site Components/Site Hero Image/Insights Hero Banner"

#$ItemPath = "master:/sitecore/content/BLG/Website/Home/about-us/News"
#$items = Get-ChildItem -Path $Targetpath -recurse -Language $Language | Where-Object {$_.TemplateName -eq 'News And Annoucement'}
#$DataSource = "/sitecore/content/BLG/Website/Site Components/Site Hero Image/News Hero Banner"

#$ItemPath = "master:/sitecore/content/BLG/Website/Home/about-us/Events"
#$items = Get-ChildItem -Path $Targetpath -recurse -Language $Language | Where-Object {$_.TemplateName -eq 'Event'}
#$DataSource = "/sitecore/content/BLG/Website/Site Components/Site Hero Image/Events Hero Banner"

$ItemPath = "master:/sitecore/content/BLG/Website/Home/about-us/Deals-and-Suits"
$items = Get-ChildItem -Path $Targetpath -recurse -Language $Language | Where-Object {$_.TemplateName -eq 'Deals and Suits'}
$DataSource = "/sitecore/content/BLG/Website/Site Components/Site Hero Image/Deals Hero Image"

$items

#Update the datasource if a hero image/banner rendering exists on the item
function Set-RenderingDatasource {
    param(
        $Page,
        $RenderingID,
        $DatasourceID,
        $IsFinalLayout
        )
    
    $renderingInstance = Get-Rendering -Item $Page -Rendering $RenderingID -EA SilentlyContinue

    if ($renderingInstance)
    {
                $renderingInstance.Datasource = $DatasourceID
                if ($IsFinalLayout) {
                    $Status = Set-Rendering -Item $Page -Instance $renderingInstance -FinalLayout -Language "en"
                    $Status = Set-Rendering -Item $Page -Instance $renderingInstance -FinalLayout -Language "fr"
                } else {
                    $Status = Set-Rendering -Item $Page -Instance $renderingInstance
                }
                if ($?)
                {
                    Write-Host -NoNewline "`t[ SET ]" -ForegroundColor green
                    Write-Host " $($RenderingID.Name) - Datasource"
                }
                else
                {
                    Write-Host -NoNewline "`t[ ERROR ]" -ForegroundColor Red
                    Write-Host " Failed while adding $($RenderingID.Name) - Datasource"
                }
    }
    else 
    {
        Write-Host -NoNewline "ERROR: " -ForegroundColor red
        Write-Host "Couldn't find [ $($RenderingID.Name) ] rendering"  #-BackgroundColor white
    }
}


#Main Function
foreach ($item in $items)
{
    Write-Host "Item: $($item.fullpath)"
    $RenderingID = Get-Item :master -ID '{AD03AD20-0BF3-4094-8F54-98A1AD17BCC4}'
    
    #final layout
    Set-RenderingDatasource -Page $item -RenderingID $RenderingID -Datasource $DataSource -IsFinalLayout true
    #shared layout
    Set-RenderingDatasource -Page $item -RenderingID $RenderingID -Datasource $DataSource -IsFinalLayout false
}

Write-Host "************************Script End************************"
