@{
    # Node specific data for standard DSC Configuration scripts and installation scripts
    Default         = @(

        # Unique Data for each Role
        @{
            JenkinsDataJSON = "\\dreamznas\Dump\githubLab\pro\ci-demo\data.json"

            NodeName                     = 'localhost'
            PSApplicationName            = 'Jenkins Job Runner'

            UserName        = "data"
            JenkinsAPIToken = "9565e9dd6e545568ac0ed1b1ff06d96b"
            BaseUri     = "http://smlin1.westeurope.cloudapp.azure.com:8080"
            JobToken = "saregama"
        }


    );
    CustomConfig = @(
        @{
            # specify any custom configuration in addition to default data here
        }
    );

} 