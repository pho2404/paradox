
function CreateTableScript {
Param ([string]$name)

$con = New-Object System.Data.Odbc.OdbcConnection
$con.ConnectionString ="DSN=GAP"


$cmd = New-Object System.Data.Odbc.OdbcCommand("select * from $name where 1 = 0" ,$con)
$cmd.Connection = $con

$con.Open()
$dr = $cmd.ExecuteReader()
$schema = $dr.GetSchemaTable();

$e = New-Object System.Data.SqlDbType


if(!($schema.Rows.Count -eq 0))
{
    Write-Output "Create table $name ("
    
    for($i = 0; $schema.Rows.Count-$i;$i++) 
    { 
    if($schema.Rows[$i].DataType.Name -eq "DateTime")
    {
        $e.value__ = 4
    }
    else
    { 
        $e.value__ = $schema.Rows[$i].ProviderType
    }
     
        $line = "[" + $schema.Rows[$i].ColumnName + "] " + $e.ToString()
        if($e.value__ -eq 3 -or $e.value__ -eq 10  -or $e.value__ -eq 11  -or $e.value__ -eq 11  -or $e.value__ -eq 12  -or $e.value__ -eq 22 )
        {
            $line = $line + "(" + [string]$schema.Rows[$i].ColumnSize + ")"
        }
        if(!($schema.Rows.Count-$i -eq 1))
        {
            $line = $line + ","
        }
        Write-Output ($line)
    }

    Write-Output (");")
    Write-Output ("")
}
else
{
    Write-Output ("")
     Write-Output ("-- Unable to string table $name")
     Write-Output ("")
}

$con.Close()
}


CreateTableScript "AWAgenda"
CreateTableScript "AWPatient"

#Get-ChildItem -Path C:\GAP\GapTS\Dossier\IKR\*.db | ForEach-Object {
#    CreateTableScript $_.BaseName
#}
