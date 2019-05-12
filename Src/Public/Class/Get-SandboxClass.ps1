function Get-SandboxClass
{
    [CmdletBinding()]
    Param()

    begin
    {
        $functionName = $MyInvocation.MyCommand.Name
        Write-Verbose "[${functionName}] Function started"
    }

    process
    {
        return $script:Sandbox
    }

    end
    {
        Write-Verbose "[${functionName}] Complete"
    }
}
