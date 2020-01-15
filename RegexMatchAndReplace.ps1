# The following script will replace space with a non-breaking space (nbsp) to comply with the French quotation and colon space rules.

# Only work under this path
$contextPath = $SitecoreContextItem.Paths.FullPath
$contentPath = "master:$contextPath/"

# Limit changes to these template IDs
$articleTemplateID = "{CFB546AA-494F-46F2-A053-9B5122FD803C}"
$podcastTemplateID = "{375A5525-98AE-4C51-BE3A-88235440D251}"
$presentationTemplateID = "{585413AD-940A-4FA4-A37D-C13C6D32F332}"
$publicationTemplateID = "{16C0A1CC-C169-4FBC-A754-510043FAFB89}"
$upcomingEventTemplateID = "{47558EBA-8D8A-4C3D-AAA5-71F5F25E72FC}"
$videoTemplateID = "{96489A12-9C95-4C52-AD76-B6AF0EBB2043}"
$perspectiveTemplateID = "{3F8FD73D-58B6-4EC3-8149-6218352B818B}"
$summaryTemplateID = "{AD1F2A97-39C8-4F00-AADF-738684C672EF}"
$bodyTextTemplateID = "{D4B16A69-01EF-4D59-9CEE-3FD31B30E96B}"

$items = Get-ChildItem -Path $contentPath `
    -Language "fr" -Recurse |
    Where-Object {  
        ($_."TemplateID" -eq $articleTemplateID -Or $_."TemplateID" -eq $podcastTemplateID -Or $_."TemplateID" -eq $presentationTemplateID -Or $_."TemplateID" -eq $publicationTemplateID -Or $_."TemplateID" -eq $upcomingEventTemplateID -Or $_."TemplateID" -eq $videoTemplateID -Or $_."TemplateID" -eq $perspectiveTemplateID -Or $_."TemplateID" -eq $summaryTemplateID -Or $_."TemplateID" -eq $bodyTextTemplateID)
    }

# Does a Regex match on the specified field for a given item then replaces the matched substrings with the given replaceString value
function FieldReplaceMatched
{
    param ($item, $fieldName, $matchRegex, $replaceString)

    $fieldValue = $item.Fields[$fieldName].Value
    if ($fieldValue -match $matchRegex)
    {
        $newFieldValue = $fieldValue -replace $matchRegex, $replaceString
        $item.Editing.BeginEdit()
        $item.Fields[$fieldName].Value = $newFieldValue
        $item.Editing.EndEdit()
        Write-Output "$fieldName field replaced with replace string: $replaceString"
    }
}

    Echo '========================================================================================================================'

foreach ($i in $items){
    Echo "`n"
    $i
    if ($i."TemplateID" -eq $bodyTextTemplateID)
    {
        $fieldName = "body"
        FieldReplaceMatched -Item $i -FieldName $fieldName -MatchRegex "( \:)" -ReplaceString '&nbsp;:'
        FieldReplaceMatched -Item $i -FieldName $fieldName -MatchRegex "(« )" -ReplaceString '« '
        FieldReplaceMatched -Item $i -FieldName $fieldName -MatchRegex "( »)" -ReplaceString ' »'
    } else {
        $fieldName = "InsightTitle"
        FieldReplaceMatched -Item $i -FieldName $fieldName -MatchRegex "( \:)" -ReplaceString ' :'
        FieldReplaceMatched -Item $i -FieldName $fieldName -MatchRegex "(« )" -ReplaceString '« '
        FieldReplaceMatched -Item $i -FieldName $fieldName -MatchRegex "( »)" -ReplaceString ' »'
        $fieldName = "Content"
        FieldReplaceMatched -Item $i -FieldName $fieldName -MatchRegex "( \:)" -ReplaceString '&nbsp;:'
        FieldReplaceMatched -Item $i -FieldName $fieldName -MatchRegex "(&laquo; )" -ReplaceString '&laquo;&nbsp;'
        FieldReplaceMatched -Item $i -FieldName $fieldName -MatchRegex "( &raquo;)" -ReplaceString '&nbsp;&raquo;'
        $fieldName = "Page Title"
        FieldReplaceMatched -Item $i -FieldName $fieldName -MatchRegex "( \:)" -ReplaceString ' :'
        FieldReplaceMatched -Item $i -FieldName $fieldName -MatchRegex "(« )" -ReplaceString '« '
        FieldReplaceMatched -Item $i -FieldName $fieldName -MatchRegex "( »)" -ReplaceString ' »'
    }
    Echo "`n"
    Echo '========================================================================================================================'
}
    Echo '===================================================== END OF SCRIPT ===================================================='
    Echo '========================================================================================================================'
