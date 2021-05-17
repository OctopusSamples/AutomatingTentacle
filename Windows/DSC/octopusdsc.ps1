Configuration SampleConfig
{
    param ($ApiKey, $OctopusServerUrl, $Environments, $Roles, $ListenPort)

    Import-DscResource -Module OctopusDSC

    Node "localhost"
    {
        cTentacleAgent OctopusTentacle
        {
            Ensure = "Present"
            State = "Started"

            # Tentacle instance name. Leave it as 'Tentacle' unless you have more
            # than one instance
            Name = "Tentacle"

            # Registration - all parameters required
            ApiKey = $ApiKey
            OctopusServerUrl = $OctopusServerUrl
            Environments = $Environments
            Roles = $Roles

            # Optional settings
            ListenPort = $ListenPort
            DefaultApplicationDirectory = "C:\Applications"
        }
    }
}

# Execute the configuration above to create a mof file
SampleConfig -ApiKey "API-YOUR_API_KEY" -OctopusServerUrl "https://YOUR_OCTOPUS/" -Environments @("Development") -Roles @("web-server", "app-server") -ListenPort 10933

# Run the configuration
Start-DscConfiguration .\SampleConfig -Verbose -wait

# Test the configuration ran successfully
Test-DscConfiguration