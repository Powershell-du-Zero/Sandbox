function Get-SandboxMappedFolder
{
    [CmdletBinding( DefaultParameterSetName = 'All' )]
    [OutputType('SandboxMappedFolder')]
    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Path'
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
        switch ($PSCmdlet.ParameterSetName)
        {
            Path { return $configuration.GetMappedFolder($Path) }
            Default { return $configuration.GetMappedFolder() }
        }
    }

    end
    {
        Write-Verbose "[${functionName}] Complete"
    }
}
