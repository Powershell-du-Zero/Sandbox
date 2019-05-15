Class SandboxService
{

    # Windows Feature Name
    [System.String]$WindowsFeatureName = 'Containers-DisposableClientVM'

    #region constructor
    SandboxService()
    { }
    #endregion

    #region Windows Feature
    [System.Void]EnableWindowsFeature()
    {
        if ($this.TestElevatedSession())
        {
            if ($this.TestWindowsFeature() -eq $false)
            {
                try
                {
                    # Enable Windows Feature
                    $splats = @{
                        FeatureName = $this.WindowsFeatureName
                        Online      = $true
                        ErrorAction = 'Stop'
                    }
                    Enable-WindowsOptionalFeature @splats
                    Write-Verbose "Successfully enabled '$($this.WindowsFeatureName)'"
                }
                catch
                {
                    throw "Failed to enable '$($this.WindowsFeatureName)'."
                }
            }
            else
            {
                throw "Unable to enable '$($this.WindowsFeatureName)' because is already enabled."
            }
        }
        else
        {
            throw "Unable to enable '$($this.WindowsFeatureName)' because youd need to have an elevation."
        }
    }

    [System.Void]DisableWindowsFeature()
    {
        if ($this.TestElevatedSession())
        {
            if ($this.TestWindowsFeature())
            {
                try
                {
                    # Disable Windows Feature
                    $splats = @{
                        FeatureName = $this.WindowsFeatureName
                        Online      = $true
                        ErrorAction = 'Stop'
                    }
                    Disable-WindowsOptionalFeature @splats
                    Write-Verbose "Successfully disabled '$($this.WindowsFeatureName)'"
                }
                catch
                {
                    throw "Failed to disable '$($this.WindowsFeatureName)'."
                }
            }
            else
            {
                throw "Unable disable '$($this.WindowsFeatureName)' because is already disabled."
            }
        }
        else
        {
            throw "Unable to disable '$($this.WindowsFeatureName)' because youd need to have an elevation."
        }
    }

    hidden [System.Boolean]TestWindowsFeature()
    {
        if ($this.TestElevatedSession())
        {
            # Get the state of the Windows Feature
            $windowsFeatureState = [System.String]::Empty
            try
            {
                $windowsFeatureState = (Get-WindowsOptionalFeature -FeatureName $this.WindowsFeatureName -Online).State
            }
            catch
            {
                throw "Failed to get the state of '$($this.WindowsFeatureName)'."
            }

            # Verify if the Windows Feature is enabled
            if ($windowsFeatureState -eq "Enabled")
            {
                return $true
            }
            else
            {
                return $false
            }
        }
        else
        {
            throw "Unable to test '$($this.WindowsFeatureName)' because youd need to have an elevation."
        }
    }
    #endregion

    #region Tools
    hidden [System.Boolean]TestElevatedSession()
    {
        $currentIdentity = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
        return $currentIdentity.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }
    #enregion

}
