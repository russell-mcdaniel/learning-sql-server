# ================================================================================
# FUNCTIONS
# ================================================================================

function Get-LoginPassword {

    $Password = Get-Content -Path "Publish-Learning-Password-Sa.txt"

    return $Password
}

# ================================================================================
# MAIN SCRIPT
# ================================================================================

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
$DatabaseName = "Learning"
$DataFileDirectory = "/var/opt/lss/mssql/data"
$LogFileDirectory = "/var/opt/lss/mssql/log"

# Configure Publishing
$DacpacFilePath = ".\bin\Debug\Learning.Database.dacpac"
$PublishProfileFilePath = ".\Publish-Learning.publish.xml"

# Deploy Database
SqlPackage `
    /Action:Publish `
    /Profile:"$PublishProfileFilePath" `
    /SourceFile:"$DacpacFilePath" `
    /TargetServerName:$ServerName `
    /TargetUser:$LoginName `
    /TargetPassword:$LoginPassword `
    /TargetDatabaseName:$DatabaseName
