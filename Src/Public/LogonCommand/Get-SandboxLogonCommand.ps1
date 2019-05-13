function Get-SandboxLogonCommand
{
    [CmdletBinding( DefaultParameterSetName = 'All' )]
    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Index'
        )]
        [System.UInt16]
        $Index,

        [Parameter(
            Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Command'
        )]
        [System.String]
        $Command,

        [Parameter(
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Type'
        )]
        [SandboxCommandType]
        $Type
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
        switch ($PSCmdlet.ParameterSetName)
        {
            Index { return $config.GetLogonCommandByIndex($Index) }
            Command { return $config.GetLogonCommandByCommand($Command) }
            Type { return $config.GetLogonCommandByType($type) }
            Default { return $config.GetLogonCommand() }
        }
    }

    end
    {
        Write-Verbose "[${functionName}] Complete"
    }
}
