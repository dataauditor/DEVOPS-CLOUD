# Ensure NBIM eventlogs are installed and available

if (Get-EventLog -LogName Application -Source NBIM -Newest 1 -ErrorAction SilentlyContinue ) { 
  Write-Host "Eventlog already exists. All OK"
} else { 
  Write-Host "Creating NBIM Eventlog"
  New-EventLog -LogName Application -Source NBIM
  Write-Eventlog -LogName Application -Source NBIM -EventId 1 -Message "Choco nbim-eventlog: Creating new eventlog Source [NBIM] by choco"
}