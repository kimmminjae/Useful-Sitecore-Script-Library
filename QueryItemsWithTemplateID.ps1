# The following script will find and list all the items matching the given template ID, field name, and field value.
# Leave the fieldValue variable empty to list all the items and field values.

# Only work under this path
$contextPath = $SitecoreContextItem.Paths.FullPath
$contentPath = "master:$contextPath/"

# Query parameters
$templateID = "{DC181CDF-76AB-45D5-9349-443AF40BD6E2}"
$fieldName = "FacetField"
$fieldValue = "regions"

$items = Get-ChildItem -Path $contentPath `
    -Recurse |
    Where-Object {  
        ($_."TemplateID" -eq $templateID)
    }

if ($fieldValue)
{
    foreach ($i in $items){
        if ($i.Fields[$fieldName].Value -eq $fieldValue){
            $i
        }
    }
} else {
    foreach ($i in $items){
        $i
        $fetchedFieldValue = $i.Fields[$fieldName].Value
        Write-Output "Field Name: $fieldName"
        Write-Output "Field Value: $fetchedFieldValue"
        Echo "`n"
        Echo '========================================================================================================================'
        Echo "`n"
    }
}
