function Export-SandboxConfiguration
{
    [CmdletBinding()]
    Param(
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.String]
        $Path
    )

    begin
    {
        # Show detailed information of this function
        $functionName = $MyInvocation.MyCommand.Name
        Write-Verbose "[${functionName}] Function started with Parameters: $( $PSBoundParameters | Out-String )"

        # Get Sandbox Class instance
        $configuration = $Script:Sandbox.Configuration
    }

    process
    {
        try
        {
            $configuration.ExportToWsb($Path)
        }
        catch
        {
            Write-Error $_.Exception.Message
        }
    }

    end
    {
        Write-Verbose "[${functionName}] Complete"
    }
}
