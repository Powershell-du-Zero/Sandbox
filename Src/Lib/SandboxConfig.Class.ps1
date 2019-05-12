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

    #region VGpu
    [SandboxStatus] GetVGpu() { return $this.VGpu }
    [System.Void] SetVGpu([SandboxStatus]$VGpu) { $this.VGpu = $VGpu }
    #endregion

    #region MappedFolder
    [System.Collections.Generic.List[SandboxMappedFolder]] GetMappedFolder() { return $this.MappedFolder }

    [SandboxMappedFolder] GetMappedFolder([System.String]$HostFolder)
    {
        return $this.MappedFolder.Where( { $_.HostFolder.FullName -eq $HostFolder })[0]
    }

    hidden [System.Boolean] TestMappedFolderName([String]$HostFolder)
    {
        return [System.Convert]::ToBoolean(
            ($this.MappedFolder.Where(
                    { $_.HostFolder.Name -eq [System.IO.DirectoryInfo]::new($HostFolder).name } )
            ).count
        )
    }

    [System.Void] AddMappedFolder([System.String]$HostFolder)
    {
        $this.AddMappedFolder($HostFolder, $true)
    }

    [System.Void] AddMappedFolder(
        [System.String]$HostFolder,
        [System.Boolean]$ReadOnly
    )
    {
        if ($this.GetMappedFolder($HostFolder).count -eq 0)
        {
            if ($this.TestMappedfolderName($HostFolder) -eq $false)
            {
                $item = [SandboxMappedFolder]::new($HostFolder, $ReadOnly)
                $this.MappedFolder.Add($item)
            }
            else
            {
                Throw "The destination folder name already in the configuration."
            }
        }
        else
        {
            Throw "The path '${HostFolder}' is already exists in the configuration."
        }
    }

    [System.Void] RemoveMappedFolder([System.String]$HostFolder)
    {
        [SandboxMappedFolder] $ItemHostFolder = $this.GetMappedFolder($HostFolder);
        if ($ItemHostFolder -ne $null)
        {
            $this.MappedFolder.Remove($ItemHostFolder);
        }
        else
        {
            Throw "Could not remove path '${HostFolder}' because it does not exist."
        }
    }

    [System.Void] ClearMappedFolder()
    {
        $this.MappedFolder = [System.Collections.Generic.List[SandboxMappedFolder]]::new()
    }
    #endregion
}
