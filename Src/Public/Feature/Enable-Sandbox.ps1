function Enable-Sandbox
{
    [CmdletBinding()]
    Param()

    begin
    {
        # Show detailed information of this function
        $functionName = $MyInvocation.MyCommand.Name
        Write-Verbose "[${functionName}] Function started"

        # Get the service instance of the Sandbox class
        $service = Get-SandboxClass -Name 'Service'
    }

    process
    {
        $service.EnableWindowsFeature()
    }

    end
    {
        Write-Verbose "[${functionName}] Complete"
    }
}
