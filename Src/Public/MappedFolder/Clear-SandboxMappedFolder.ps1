function Clear-SandboxMappedFolder
{
    [CmdletBinding()]
    Param()

    begin
    {
        # Show detailed information of this function
        $functionName = $MyInvocation.MyCommand.Name
        Write-Verbose "[${functionName}] Function started"

        # Get the configuration instance of the Sandbox class
        $config = Get-SandboxClass -Name 'Config' -Cache
    }

    process
    {
        $config.ClearMappedFolder()
    }

    end
    {
        Write-Verbose "[${functionName}] Complete"
    }
}
