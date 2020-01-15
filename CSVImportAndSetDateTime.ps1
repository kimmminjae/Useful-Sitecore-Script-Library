$rootItem = Get-Item master:/content;
$importData = Import-CSV "D:\home\site\wwwroot\temp\EventsToBeRestored.csv"
foreach ( $row in $importData ) {
    $item = Get-Item $row.ItemID
    $item
    $match = $row.EventStartDate -match '[0-9][0-9]?\/[0-9][0-9]?\/[0-9][0-9][0-9][0-9]'
    $eventStartDateMonthYear = ($matches[0] -split '\/').Trim();
    if ($eventStartDateMonthYear[0].length -lt 2) {
        $eventStartDateMonthYear[0] = "0"+$eventStartDateMonthYear[0]
    }
        if ($eventStartDateMonthYear[1].length -lt 2) {
        $eventStartDateMonthYear[1] = "0"+$eventStartDateMonthYear[1]
    }
    $eventStartDate = $eventStartDateMonthYear[2]+$eventStartDateMonthYear[0]+$eventStartDateMonthYear[1]
    $match = $row.EventStartDate -match '[0-9][0-9]:[0-9][0-9]'
    $eventStartHourMin = ($matches[0] -split ':').Trim();
    $eventStartTime = $eventStartHourMin[0]+$eventStartHourMin[1]  + "00"
    $eventStart = $eventStartDate + "T" + $eventStartTime + "Z"
    $eventStart
    
    $match = $row.EventEndDate -match '[0-9][0-9]?\/[0-9][0-9]?\/[0-9][0-9][0-9][0-9]'
    $eventEndDateMonthYear = ($matches[0] -split '\/').Trim();
    if ($eventEndDateMonthYear[0].length -lt 2) {
        $eventEndDateMonthYear[0] = "0"+$eventEndDateMonthYear[0]
    }
        if ($eventEndDateMonthYear[1].length -lt 2) {
        $eventEndDateMonthYear[1] = "0"+$eventEndDateMonthYear[1]
    }
    $eventEndDate = $eventEndDateMonthYear[2]+$eventEndDateMonthYear[0]+$eventEndDateMonthYear[1]
    $match = $row.EventEndDate -match '[0-9][0-9]:[0-9][0-9]'
    $eventEndHourMin = ($matches[0] -split ':').Trim();
    $eventEndTime = $eventEndHourMin[0]+$eventEndHourMin[1] + "00"
    $eventEnd = $eventEndDate + "T" + $eventEndTime + "Z"
    $eventEnd
    
    $item.Editing.BeginEdit()
    $item.Fields['EventStartDate'].Value = $eventStart
    $item.Fields['EventEndDate'].Value = $eventEnd
    $item.Fields['LocationAddress'].Value = $row.LocationAddress
    $item.Fields['LocationName'].Value = $row.LocationName
    $item.Fields['LocationSummary'].Value = $row.LocationSummary
    $item.Editing.EndEdit()
}
