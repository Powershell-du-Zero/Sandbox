function Remove-SandboxLogonCommand
{
    [CmdletBinding()]
    Param(
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.String]
        $Index
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
        if (Get-SandboxLogonCommand -Index $Index)
        {
            try
            {
                $config.RemoveLogonCommand($Index)
            }
            catch
            {
                Write-Error $_.Exception.Message
            }
        }
        else
        {
            Write-Error "Cannot find index '${Index}' because it does not exist in configuration."
        }
    }

    end
    {
        Write-Verbose "[${functionName}] Complete"
    }
}
