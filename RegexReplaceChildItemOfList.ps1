# The following script will find and list all the items matching the given template ID, field name, and field value.
# Leave the fieldValue variable empty to list all the items and field values.

# Only work under this path
$contextPath = $SitecoreContextItem.Paths.FullPath
$contentPath = "master:$contextPath/"

# Query parameters
$templateID = "{839B2143-30C1-41B1-A962-E9E097936C9C}"
$BioFirstName = "BioFirstName"
$BioLastName = "BioLastName"
$fieldValue = ""

$items = Get-ChildItem -Path $contentPath `
    -Recurse |
    Where-Object {
        ($_."TemplateID" -eq $templateID)
    }


foreach ($i in $items) {
    $i
    $itemPath = $i.Paths.FullPath
    $itemFullPath = "master:$itemPath/"
    $fetchedBioFirstName = $i.Fields[$BioFirstName].Value
    $fetchedBioLastName = $i.Fields[$BioLastName].Value
    if ($fetchedBioFirstName) {
        if ($fetchedBioLastName) {
            Write-Output "First Name: $fetchedBioFirstName"
            Write-Output "Last Name: $fetchedBioLastName"
            $insightsRollups = Get-ChildItem -Path $itemFullPath `
                -Recurse |
                Where-Object {
                    ($_."TemplateID" -eq "{10DB37AF-8F6C-4B5A-9813-A12D2E162454}")
                }
            foreach ($insightsRollup in $insightsRollups) {
                $oldValue = $insightsRollup.Fields["View All Insights Link"].Value
                $regex = '(anchor=\"f:authors=\[.*\]\")'
                if ($oldValue -match $regex)
                {
                    $prefix = 'anchor="f:@authors=['
                    $postfix = ']"'
                    $newValue = $oldValue -replace $regex, "$prefix$fetchedBioFirstName $fetchedBioLastName$postfix"
                    $oldValue
                    $newValue
                    
                    $insightsRollup.Editing.BeginEdit()
                    $insightsRollup.Fields["View All Insights Link"].Value = $newValue
                    $insightsRollup.Editing.EndEdit()
                }
            }
        }
    }

    Echo "`n"
    Echo '========================================================================================================================'
    Echo "`n"
}
