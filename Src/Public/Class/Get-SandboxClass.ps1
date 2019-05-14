function Get-SandboxClass
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
        $Name,

        [Parameter(
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Switch]
        $Cache
    )

    begin
    {
        $functionName = $MyInvocation.MyCommand.Name
        Write-Verbose "[${functionName}] Function started"
    }

    process
    {
        if ($Cache)
        {
            $sandboxObject = Get-Variable -Name "Sandbox${Name}" -Scope 'Script' -ErrorAction SilentlyContinue -ValueOnly
            if ( $null -eq $sandboxObject )
            {
                $sandboxObject = New-SandboxClass -Name $Name
                Set-Variable -Name "Sandbox${Name}" -Value $sandboxObject -Scope 'Script'
                return $sandboxObject
            }
            return $sandboxObject
        }
        else
        {
            New-SandboxClass -Name $Name
        }
    }

    end
    {
        Write-Verbose "[${functionName}] Complete"
    }
}
