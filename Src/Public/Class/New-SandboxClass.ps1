function New-SandboxClass
{
    [CmdletBinding()]
    Param(
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet('Config', 'Service')]
        [System.String]
        $Name
    )

    begin
    {
        # Show detailed information of this function
        $functionName = $MyInvocation.MyCommand.Name
        Write-Verbose "[${functionName}] Function started with Parameters: $( $PSBoundParameters | Out-String )"
    }

    process
    {
        return New-Object -TypeName "Sandbox${Name}"
    }

    end
    {
        Write-Verbose "[${functionName}] Complete"
    }



}
