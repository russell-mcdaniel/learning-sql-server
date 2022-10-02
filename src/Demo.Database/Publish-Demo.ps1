param
(
    [switch] $CreateNewDatabase = $false
)

function Get-LoginPassword {

    $Password = Get-Content -Path "Publish-Demo-Password-Sa.txt"

    return $Password
}

# Configure Path
$SqlPackageDirectory = "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\Extensions\Microsoft\SQLDB\DAC"

If (-Not $env:Path.Contains($SqlPackageDirectory))
{
    $env:Path = $env:Path + ";" + $SqlPackageDirectory
}

# Configure Server
$ServerName = "(local)"
$LoginName = "sa"
$LoginPassword = Get-LoginPassword

# Configure Database
$DatabaseName = "Demo"
$DataFileDirectory = "/var/opt/demo/mssql/data"
$LogFileDirectory = "/var/opt/demo/mssql/log"

# Configure Publishing
$DacpacFilePath = ".\bin\Debug\Demo.Database.dacpac"
$PublishProfileFilePath = ".\Publish-Demo.publish.xml"

# Deploy Database
SqlPackage `
    /Action:Publish `
    /Profile:"$PublishProfileFilePath" `
    /SourceFile:"$DacpacFilePath" `
    /TargetServerName:$ServerName `
    /TargetUser:$LoginName `
    /TargetPassword:$LoginPassword `
    /TargetDatabaseName:$DatabaseName `
    /p:CreateNewDatabase=$CreateNewDatabase
