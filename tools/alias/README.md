This is a PowerShell script that creates SQL Server aliases.

I created this several years ago when I could not find any tools or scripts for creating aliases at the command line to support build automation scenarios. It turned out to be much more challenging than I expected. Check out the comments in the script for details.

There are probably better options by now.

The `New-DbaClientAlias` cmdlet provided by [dbatools](https://dbatools.io/) might be one of them.

## References

https://dbatools.io/aliases/

https://docs.dbatools.io/New-DbaClientAlias

https://github.com/dataplat/dbatools/blob/development/functions/New-DbaClientAlias.ps1
