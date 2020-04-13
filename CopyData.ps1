
Add-Type -Path "C:\Program Files (x86)\System.Data.SQLite\2010\bin\System.Data.SQLite.dll"

function CopyTable {
Param ([string]$from, [string]$to,[string]$dsn)


$conSource = New-Object System.Data.Odbc.OdbcConnection
$conSource.ConnectionString ="DSN=$dsn"
$conSource.Open()
Write-Output ("Connection open")
$cmdSource = New-Object System.Data.Odbc.OdbcCommand("select * from $from" ,$conSource)
Write-Output ("Reading")
$dr = $cmdSource.ExecuteReader()
Write-Output ("Loading data")
$dt = New-Object System.Data.DataTable
$dt.Load($dr)

Write-Output ("Creating Destination")
$conDest = New-Object System.Data.SQLite.SQLiteConnection
$conDest.ConnectionString = "Data Source=c:\tools\sqllite\$dsn.db"

$da = New-Object System.Data.SQLite.SQLiteDataAdapter("select * from $to", $conDest)
$cb = New-Object System.Data.SQLite.SQLiteCommandBuilder($da)
$cb.QuotePrefix = "[";  
$cb.QuoteSuffix = "]";  

Write-Output ("Copied table")


$dtDest = New-Object System.Data.DataTable
$dtDest = $dt.Copy()

Write-Output ("Changing Status")
for ($i=0;$dtDest.Rows.Count-$i;$i++)
{
    $dtDest.Rows[$i].SetAdded();
}

$da.UpdateBatchSize = 0

Write-Output ("Inserting data")
$da.Update($dtDest)
Write-Output ("Done.")
}

CopyTable -from "AWPatient" -to "AWPatient" -dsn "IKR"