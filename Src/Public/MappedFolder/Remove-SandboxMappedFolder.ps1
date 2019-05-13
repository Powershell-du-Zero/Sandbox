function Remove-SandboxMappedFolder
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
        $config = $Script:Sandbox.Config
    }

    process
    {
        if (Get-SandboxMappedFolder -Path $Path)
        {
            try
            {
                $config.RemoveMappedFolder($Path)
            }
            catch
            {
                Write-Error $_.Exception.Message
            }
        }
        else
        {
            Write-Error "Cannot find folder '${Path}' because it does not exist in configuration."
        }
    }

    end
    {
        Write-Verbose "[${functionName}] Complete"
    }
}
