Function Send-TCPMessage
{
    <#
        .SYNOPSIS
        Describe purpose of "Disconnect-UDPClient" in 1-2 sentences.

        .DESCRIPTION
        Add a more complete description of what the function does.

        .EXAMPLE
        Disconnect-UDPClient
        Describe what this call does

        .NOTES
        Place additional notes here.

        .LINK
        URLs to related sites
        The first link is opened by Get-Help -Online Disconnect-UDPClient

        .INPUTS
        List of input types that are accepted by this function.

        .OUTPUTS
        List of output types produced by this function.
    #>
    param
    (
        # Parameter help description
        [Parameter(Mandatory = $true,HelpMessage='Add help message for user')]
        [ValidateNotNullOrEmpty()]
        [System.IO.StreamWriter]
        $TcpWriter,

        # Parameter help description
        [Parameter(Mandatory = $true)]
        [byte[]]
        $Datagram
    )
    Write-Verbose ([Text.Encoding]::ASCII.GetString($Datagram)) -Verbose

    $null = $TcpWriter.Write($Datagram, 0, $Datagram.Length)

}