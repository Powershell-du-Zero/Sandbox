Class SandboxConfig
{
    #Region Properties
    # Enable or disable networking in the sandbox
    hidden [SandboxStatus]$Networking

    # Enable or disable the virtualized GPU
    hidden [SandboxStatus]$VGpu

    # List of script or program executions at startup
    hidden [System.Collections.Generic.List[SandboxLogonCommand]]$LogonCommand

    # List of shared folders of the host
    hidden [System.Collections.Generic.List[SandboxMappedFolder]]$MappedFolder
    #endregion

    #region Constructors
    SandboxConfig()
    {
        $this.Networking = [SandboxStatus]::Enable
        $this.VGpu = [SandboxStatus]::Disable
        $this.LogonCommand = [System.Collections.Generic.List[SandboxLogonCommand]]::new()
        $this.MappedFolder = [System.Collections.Generic.List[SandboxMappedFolder]]::new()
    }

    SandboxConfig(
        [SandboxStatus]$Networking,
        [SandboxStatus]$VGpu
    )
    {
        $this.Networking = [SandboxStatus]::Enable
        $this.VGpu = [SandboxStatus]::Disable
        $this.LogonCommand = [System.Collections.Generic.List[SandboxLogonCommand]]::new()
        $this.MappedFolder = [System.Collections.Generic.List[SandboxMappedFolder]]::new()
    }
    #endregion

    #region Config
    [System.Object] GetConfig()
    {
        return [PSCustomObject]@{
            Networking   = $this.Networking
            VGpu         = $this.VGpu
            LogonCommand = $this.LogonCommand
            MappedFolder = $this.MappedFolder
        }
    }
    #endregion

    #region Networking
    [SandboxStatus] GetNetworking() { return $this.Networking }
    [System.Void] SetNetworking([SandboxStatus]$Networking) { $this.Networking = $Networking }
    #endregion
}
