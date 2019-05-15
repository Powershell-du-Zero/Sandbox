function Set-SandboxVGpu
{
    [CmdletBinding()]
    [OutputType('System.Void')]
    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [SandboxStatus]$Status
    )

    begin
    {
        # Show detailed information of this function
        $functionName = $MyInvocation.MyCommand.Name
        Write-Verbose "[${functionName}] Function started with Parameters: $( $PSBoundParameters | Out-String )"

        # Get the configuration instance of the Sandbox class
        $config = Get-SandboxClass -Name 'Config' -Cache
    }

    process
    {
        return $config.SetVGpu($Status)
    }

    end
    {
        Write-Verbose "[${functionName}] Complete"
    }
}
