Configuration InstallIIS
{
  Node $env:ComputerName
  {
    #Install the IIS Role
    WindowsFeature IIS
    {
      Ensure = “Present”
      Name = “Web-Server”
    }

    #Install ASP.NET 4.5
    WindowsFeature ASP
    {
      Ensure = “Present”
      Name = “Web-Asp-Net45”
    }

     WindowsFeature WebServerManagementConsole
    {
        Name = "Web-Mgmt-Console"
        Ensure = "Present"
    }
	File Directory
	{
		Type = 'Directory'
		DestinationPath = 'C:\DCPInstall'
		Ensure = 'Present'
	}
    Script DownloadWebApp
    {
        GetScript = 
        {
            @{
                GetScript = $GetScript
                SetScript = $SetScript
                TestScript = $TestScript
                Result = ('True' -in (Test-Path C:\DCPInstall\SampleASPNetApp.zip))
            }
        }
        SetScript = 
        {
            Invoke-WebRequest -Uri "https://demosto2304.blob.core.windows.net/demoenv/SampleASPNetApp.zip" -OutFile "C:\DCPInstall\SampleASPNetApp.zip"
        }

        TestScript = 
        {
            $Status = ('True' -in (Test-Path C:\DCPInstall\SampleASPNetApp.zip))
            $Status -eq $True
        }
    }
    Archive UnzipWebApp {
        Ensure = 'Present'
        Path = 'C:\DCPInstall\SampleASPNetApp.zip'
        Destination = 'C:\inetpub\wwwroot'
    }
  }
} 