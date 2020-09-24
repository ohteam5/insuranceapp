<#

.SYNOPSIS
    Healthcheck the Uri and display the result.

.DESCRIPTION
    The polling.ps1 display the helthcheck result for each second. You will see the format
    [Timestamp] | [StatusCode] | [Uri]

.PARAMETER Uri
    The target uri for checking the status

.PARAMETER displayUri
    If $true, it displays the Uri in output

.EXAMPLE
PS > .\polling.ps1 -Uri https://github.com/Azure-Samples/openhack-devops-proctor -displayUri $true
.\polling.ps1 -Uri https://github.com/Azure-Samples/openhack-devops-proctor -displayUri $true
21/03/2019 14:21:17 | 200 | https://github.com/Azure-Samples/openhack-devops-proctor
21/03/2019 14:21:21 | 200 | https://github.com/Azure-Samples/openhack-devops-proctor

.EXAMPLE
PS > .\polling.ps1 -Uri https://github.com/Azure-Samples/openhack-devops-proctor
21/03/2019 14:21:55 | 200
21/03/2019 14:21:58 | 200

#>

Param(
    [string] [Parameter(Mandatory=$true)] $Uri,
    [boolean] [Parameter(Mandatory=$false)] $displayUri
    )

$sucessCount = 0

For ($i=0; $i -lt 12; $i++)
{
try
{
  $R = Invoke-WebRequest -URI $Uri
  
  $timestamp = Get-Date
  $output = ""

  if ($displayUri) 
  {
    $output = $output = '{0} | {1} | {2}' -f($timestamp, $R.StatusCode, $Uri)
  } else 
  {

    $output = '{0} | {1}' -f($timestamp, $R.StatusCode)
  }

  if ($R.StatusCode -eq 200)
  {
      $sucessCount = $sucessCount +1
  }

  Write-Output $output

  if ($sucessCount -gt 4)
  {
      break
  }
}
catch 
{
    Write-Output $R
}
  Start-Sleep -Seconds 10
}

if ($sucessCount -gt 4)
{
    exit 0
}
else
{
    exit 1
}
