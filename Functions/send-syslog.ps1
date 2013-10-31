Add-Type -TypeDefinition @"
	public enum syslog_facility
	{
		kern,
		user,
		mail,
		daemon,
		auth,
		syslog,
		lpr,
		news,
		uucp,
		Clock,
		authpriv,
		ftp,
		ntp,
		logaudit,
		logalert,
		cron, 
		local0,
		local1,
		local2,
		local3,
		local4,
		local5,
		local6,
		local7,
	}
"@

Add-Type -TypeDefinition @"
	public enum Syslog_severity
	{
		Emergency,
		Alert,
		Critical,
		Error,
		Warning,
		Notice,
		Informational,
		Debug
	}
"@

function send-syslogmessage
{
[CMDLetBinding()]
Param
(
	[Parameter(mandatory=$true)] [String] $server,
	[Parameter(mandatory=$true)] [String] $message,
	[Parameter(mandatory=$true)] [Syslog_severity] $Severity,
	[Parameter(mandatory=$true)] [syslog_facility] $facility,
	[String] $hostname,
	[String] $timestamp,
	[int] $UDPPort = 514
)

$UDPCLient = New-Object System.Net.Sockets.UdpClient
$UDPCLient.Connect($server, $UDPPort)
$facility_num = $facility.value__
$severity_num = $Severity.value__
Write-Verbose "Syslog Facility, $facility_num, Severity is $severity_num"

# Calculate the PRI code
$pri = ($facility_num * 8) + $severity_num

Write-Verbose "Priority is $pri"

if (($hostname -eq "") -or ($hostname -eq $null))
{
	$hostname = hostname
}

if (($timestamp -eq "") -or ($timestamp -eq $null))
{
	$timestamp = Get-Date -Format "yyyy:MM:dd:-HH:mm:ss zzz"
}

# Get a properly formatted, encoded, and length limited data string
$syslogmessage = "<{0}>{1} {2} {3}" -f $pri, $timestamp, $hostname, $message

Write-Verbose "========================================"
Write-Verbose $syslogmessage
Write-Verbose "========================================"

$enc     = [System.Text.Encoding]::ASCII
$syslogmessage = $Enc.GetBytes($syslogmessage)
    
if ($syslogmessage.Length -gt 1024)
{
    $syslogmessage = $syslogmessage.SubString(0, 1024)
}

# Fire away
$UDPCLient.Send($syslogmessage, $syslogmessage.Length)

}
