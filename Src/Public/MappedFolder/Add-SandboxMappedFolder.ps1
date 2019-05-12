function Add-SandboxMappedFolder
{
    [CmdletBinding()]
    [OutputType('System.Void')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.String]
        $Path,

        [Parameter(
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.Boolean]
        $ReadOnly = $true,

        [Parameter(
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Switch]
        $SkipPathCheck
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
        # Test the path to avoid configuration errors
        if ((Test-Path -Path $Path) -or $SkipPathCheck)
        {
            try
            {
                # Add a new mapped folder in the configuration
                $configuration.AddMappedFolder($Path, $ReadOnly)
            }
            catch
            {
                Write-Error $_.Exception.Message
            }
        }
        else
        {
            Write-Error "Cannot find path '${Path}' because it does not exist."
        }
    }

    end
    {
        Write-Verbose "[${functionName}] Complete"
    }
}
