Class MappedFolder
{

    [System.IO.DirectoryInfo]$HostFolder
    [System.IO.DirectoryInfo]$RemoteFolder
    [System.Boolean]$ReadOnly
    hidden [System.String]$RemoteBasePath = 'C:\Users\WDAGUtilityAccount\Desktop'

    MappedFolder(
        [System.String]$HostFolder,
        [System.Boolean]$ReadOnly
    )
    {
        $This.HostFolder = [System.IO.DirectoryInfo]::new($HostFolder)
        $This.RemoteFolder = [System.IO.DirectoryInfo]::new([System.IO.Path]::Combine($this.RemoteBasePath, $this.HostFolder.Name))
        $This.ReadOnly = $ReadOnly;
    }

}
