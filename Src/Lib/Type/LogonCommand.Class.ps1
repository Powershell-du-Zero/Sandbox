Class LogonCommand
{

    [System.UInt16] $Index
    [System.String] $Command
    [CommandType] $Type
    [System.String] $Description

    LogonCommand(
        [System.UInt16]$Index,
        [System.String]$Command,
        [CommandType]$Type,
        [System.String]$Description
    )
    {
        $this.Index = $Index;
        $this.Command = $Command;
        $this.Type = $Type;
        $this.Description = $Description;
    }

}
