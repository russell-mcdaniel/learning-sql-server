#
# Creates a SQL Server alias.
#
# Two requirements must be met for this process to succeed:
#
# * The script must run as an administrator in order to write to the registry.
#
# * The script must run as a 64-bit process in order to write both registry keys. If not, the
#   registry redirector in the Wow64 subsystem will prevent the 64-bit key from being written.
#
# If the script is not running with administrator privileges, it must be elevated. In order
# to elevate, the script must be relaunched with the -Verb RunAs option of Start-Process.
#
# If the script is not running in a 64-bit process, it must be relaunched in a 64-bit instance
# of PowerShell. This is done by using the "Sysnative" alias to override the file system
# redirector in the Wow64 subsystem.
#
# However, the -Verb RunAs option interferes with the file system redirector and causes the
# "Sysnative" alias to be interpretted as a literal value which prevents the 64-bit version
# of PowerShell from being located when launched from a 32-bit process.
#
# To handle this, the script can relaunch itself up to two times, once for each condition
# (as necessary), in order to meet its processing requirements.
#
# Other Notes
#
# * The script currently supports only Windows PowerShell (not PowerShell Core).
#
# * The -NoNewWindow option of Start-Process is not compatible with the -Verb RunAs option.
#   The window may be hidden, however (-WindowStyle Hidden).
#

param (
	[Parameter(Mandatory = $true)]
	[string]$AliasName,

	[Parameter(Mandatory = $true)]
	[ValidateSet("np", "tcp")]
	[string]$Protocol,

	[Parameter(Mandatory = $true)]
	[string]$ServerName,

	[string]$InstanceName = $null,

	[string]$Port = $null,

	[switch]$Force = $false
)

Function Get-ArgumentList {

	$ArgumentList = "-NoProfile -NonInteractive -ExecutionPolicy Unrestricted -Command `"& { $PSScriptRoot\New-SqlAlias.ps1 -AliasName $AliasName -Protocol $Protocol -ServerName $ServerName"

	If (-Not [String]::IsNullOrWhiteSpace($InstanceName)) {
		$ArgumentList = $ArgumentList + " -InstanceName $InstanceName"
	}

	If (-Not [String]::IsNullOrWhiteSpace($Port)) {
		$ArgumentList = $ArgumentList + " -Port $Port"
	}

	If ($Force) {
		$ArgumentList = $ArgumentList + " -Force"
	}

	$ArgumentList = $ArgumentList + " }`""

	Return $ArgumentList
}

Function Get-SqlServerAliasValueData {

	$ValueData = ""

	Switch ($Protocol) {

		"np" {

			$ValueData = "DBNMPNTW,\\$ServerName"

			If (-Not [String]::IsNullOrWhiteSpace($InstanceName)) {
				$ValueData = "$ValueData\PIPE\MSSQL`$$InstanceName\sql\query"
			}
			Else {
				$ValueData = "$ValueData\PIPE\sql\query"
			}
		}

		"tcp" {

			$ValueData = "DBMSSOCN,$ServerName"

			If (-Not [String]::IsNullOrWhiteSpace($InstanceName)) {
				$ValueData = "$ValueData\$InstanceName"
			}

			If (-Not [String]::IsNullOrWhiteSpace($Port)) {
				$ValueData = "$ValueData,$Port"
			}
		}
	}

	Return $ValueData
}

Function Test-IsAdministrator {

	If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
		Return $true
	}

	Return $false
}

Function Test-IsX64 {

	Return [System.Environment]::Is64BitProcess
}

Function Test-RegistryValueExists {

	param (
		[string]$Path,
		[string]$ValueName
	)

	If (Test-Path $Path)
	{
		$Key = Get-Item -LiteralPath $Path

		If ($Key.GetValue($ValueName, $null) -ne $null)
		{
			Return $true
		}

	}

	Return $false
}

# Set the error behavior.
$ErrorActionPreference = "Stop"

# Get the operating environment.
$IsX64 = Test-IsX64
$IsAdministrator = Test-IsAdministrator

# Set the registry key paths.
$Path64 = "HKLM:\SOFTWARE\Microsoft\MSSQLServer\Client\ConnectTo"
$Path32 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\MSSQLServer\Client\ConnectTo"

# Check if the alias already exists.
$HasValue = Test-RegistryValueExists -Path "$Path64" -ValueName "$AliasName"

# Create the registry key value data for the alias.
$ValueData = Get-SqlServerAliasValueData

# Create the registry value. If the value already exists, display a warning. Only
# overwrite the existing value if the Force option is set.
$WriteValue = $false

If (($HasValue) -And (-Not $Force)) {

	Write-Output "The specified alias exists. Use the -Force option to overwrite it."
}
ElseIf (($HasValue) -And ($Force)) {

	Write-Output "The specified alias exists. It will be overwritten because -Force was specified."

	$WriteValue = $true
}
Else {
	$WriteValue = $true
}

If ($WriteValue) {

	If (-Not $IsX64) {

		Write-Output "Writing to the registry requires a 64-bit process; rerunning the process as 64-bit."

		# Get the PowerShell path.
		$PowerShell = Join-Path ($PSHome -Replace "SysWOW64", "Sysnative") "powershell.exe"

		# Get the original arguments.
		$ArgumentList = Get-ArgumentList

		# Run the process as 64-bit.
		$Process = Start-Process -FilePath "$PowerShell" -ArgumentList $ArgumentList -Wait -PassThru -NoNewWindow

		Exit $Process.ExitCode
	}

	If (-Not $IsAdministrator) {

		Write-Output "Writing to the registry requires elevated privileges; rerunning the process as an administrator."

		# Get the PowerShell path.
		$PowerShell = Join-Path $PSHome "powershell.exe"

		# Get the original arguments.
		$ArgumentList = Get-ArgumentList

		# Run the process as an administrator.
		$Process = Start-Process -FilePath "$PowerShell" -ArgumentList $ArgumentList -Wait -PassThru -WindowStyle Hidden -Verb RunAs

		Exit $Process.ExitCode
	}

	# Update the registry if both requirements are met.
	If (($IsX64) -And ($IsAdministrator)) {

		Write-Output "Writing to the registry..."

		New-ItemProperty -Path $Path64 -Name $AliasName -PropertyType String -Value $ValueData -Force
		New-ItemProperty -Path $Path32 -Name $AliasName -PropertyType String -Value $ValueData -Force

		Write-Output "Writing to the registry complete."
	}
}
