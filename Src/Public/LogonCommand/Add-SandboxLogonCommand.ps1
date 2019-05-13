function Add-SandboxLogonCommand
{
    [CmdletBinding( DefaultParameterSetName = 'Default' )]
    [OutputType('System.Void')]
    param(
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
            ValueFromPipelineByPropertyName = $true
        )]
        [System.String]
        $Command,

        [Parameter(
            Position = 2,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [SandboxCommandType]
        $type = 'PowershellScript',

        [Parameter(
            Position = 3,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.String]
        $Description = [System.String]::Empty
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
            Index { return $config.AddLogonCommand($Index,$Command,$Type,$Description) }
            Default { return $config.AddLogonCommand($Command,$Type,$Description) }
        }
    }

    end
    {
        Write-Verbose "[${functionName}] Complete"
    }
}
