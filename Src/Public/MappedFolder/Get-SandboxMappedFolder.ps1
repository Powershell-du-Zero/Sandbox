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

        # Get the configuration instance of the Sandbox class
        $config = Get-SandboxClass -Name 'Config' -Cache
    }

    process
    {
        switch ($PSCmdlet.ParameterSetName)
        {
            Path { return $config.GetMappedFolder($Path) }
            Default { return $config.GetMappedFolder() }
        }
    }

    end
    {
        Write-Verbose "[${functionName}] Complete"
    }
}
