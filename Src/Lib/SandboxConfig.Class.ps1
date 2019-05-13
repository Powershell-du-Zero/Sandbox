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

    #region LogonCommand
    [System.Collections.Generic.List[SandboxLogonCommand]] GetLogonCommand() { return $this.LogonCommand }

    [SandboxLogonCommand] GetLogonCommandByIndex([System.Int16]$Index)
    {
        return $this.LogonCommand.Where( { $_.Index -eq $Index })[0]
    }

    [SandboxLogonCommand] GetLogonCommandByCommand([System.String]$Command)
    {
        return $this.LogonCommand.Where( { $_.Command -eq $Command })[0]
    }

    [SandboxLogonCommand[]] GetLogonCommandByType([SandboxCommandType]$Type)
    {
        return $this.LogonCommand.Where( { $_.Type -eq [SandboxCommandType]$Type })
    }

    [System.Void] ClearLogonCommand()
    {
        $this.LogonCommand = [System.Collections.Generic.List[SandboxLogonCommand]]::new()
    }

    hidden [System.Int16] GetLogonCommandNextIndex()
    {
        if ($this.LogonCommand.count -gt 0)
        {
            # TODO : Convert the line below to .net ( .sort() )
            $nextIndex = ($this.LogonCommand.Index | Sort-Object -Descending)[0] + 1
            return $nextIndex
        }
        else
        {
            return 1
        }
    }

    [System.Void] AddLogonCommand(
        [System.String]$Command,
        [SandboxCommandType]$Type
    )
    {
        [System.UInt16]$index = $this.GetLogonCommandNextIndex()
        $this.AddLogonCommand($index, $Command, $Type, '')
    }

    [System.Void] AddLogonCommand(
        [System.String]$Command,
        [SandboxCommandType]$Type,
        [System.String]$Description
    )
    {
        [System.UInt16]$index = $this.GetLogonCommandNextIndex()
        $this.AddLogonCommand($index, $Command, $Type, $Description)
    }

    [System.Void] AddLogoncommand(
        [system.UInt16]$Index,
        [System.String]$Command,
        [SandboxCommandType]$Type,
        [System.String]$Description
    )
    {
        if ( $this.GetLogonCommandByIndex($Index).count -eq 0 )
        {
            if ( $this.GetLogonCommandByCommand($Command).count -eq 0 )
            {
                $logonCommandItem = [SandboxLogonCommand]::new($Index, $Command, $Type, $Description)
                $this.LogonCommand.add($logonCommandItem)
            }
            else
            {
                Throw "Could not add command '${Command}' because is already exist in configuration."
            }
        }
        else
        {
            Throw "Could not add command because this index '${Index}' is already exist in configuration."
        }
    }

    [System.Void] RemoveLogonCommand([System.UInt16]$Index)
    {
        $commandItem = $this.GetLogonCommandByIndex($Index)
        if ($commandItem)
        {
            $this.LogonCommand.Remove($commandItem)
        }
        else
        {
            Throw "Could not remove command because this index '${Index}' does not exist."
        }
    }
    #endregion

    #region
    [System.Void] ExportToWsb([System.String]$Path)
    {
        # Xml Settings
        [System.Xml.XmlWriterSettings] $xmlWriterSettings = [System.Xml.XmlWriterSettings]::new()
        $xmlWriterSettings.Encoding = [System.Text.Encoding]::UTF8
        $xmlWriterSettings.OmitXmlDeclaration = $true
        $xmlWriterSettings.Indent = $true
        $xmlWriterSettings.IndentChars = '    '

        # Get an XMLTextWriter to create the XML
        [System.Xml.XmlWriter] $XmlWriter = [System.Xml.XmlWriter]::Create($Path, $xmlWriterSettings)

        # Create root element "Configuration"
        $xmlWriter.WriteStartDocument()
        $xmlWriter.WriteStartElement("Configuration")

        # Networking
        $xmlWriter.WriteStartElement("Networking")
        $xmlWriter.WriteRaw($this.Networking.ToString())
        $xmlWriter.WriteEndElement()

        # VGpu
        $xmlWriter.WriteStartElement("VGpu")
        $xmlWriter.WriteRaw($this.VGpu.ToString())
        $xmlWriter.WriteEndElement()

        # MappedFolder
        if ($this.MappedFolder.Count -gt 0)
        {
            $xmlWriter.WriteStartElement("MappedFolders");
            foreach ($mappedFolderItem in $this.MappedFolder)
            {
                $xmlWriter.WriteStartElement("MappedFolder")
                $xmlWriter.WriteStartElement("HostFolder")
                $xmlWriter.WriteRaw($mappedFolderItem.HostFolder.FullName)
                $xmlWriter.WriteEndElement()
                $xmlWriter.WriteStartElement("ReadOnly")
                $xmlWriter.WriteRaw($mappedFolderItem.ReadOnly.ToString().ToLower())
                $xmlWriter.WriteEndElement()
                $xmlWriter.WriteEndElement()
            }
            $xmlWriter.WriteEndElement()
        }

        # LogonCommand
        # TODO : Convert Sort-Object to .net class
        if ($this.LogonCommand.Count -gt 0)
        {
            $xmlWriter.WriteStartElement("LogonCommand")
            foreach ($logonCommandItem in ($this.LogonCommand | Sort-Object -Property Index) )
            {
                $xmlWriter.WriteStartElement("Command")
                $xmlWriter.WriteRaw($logonCommandItem.Command)
                $xmlWriter.WriteEndElement()
            }
            $xmlWriter.WriteEndElement()
        }

        #Close the "Configuration" node:
        $xmlWriter.WriteEndElement()

        # Finalize the document:
        $xmlWriter.WriteEndDocument()
        $xmlWriter.Flush()
        $xmlWriter.Close()
        $xmlWriter.Dispose()
    }
    #endregion
}
