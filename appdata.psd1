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
            #JOB_URL = "http://smlin1.westeurope.cloudapp.azure.com:8080/job/batch-ci-stack2/"

            # Role                         = @('Web', 'PullServer')
           
            # PullServerEndPointName       = 'CtrDSCSrv'
            # PullserverPort               = 8080  
            # PullServerWebRoot            = "$env:SystemDrive\inetpub\wwwroot\PSDSCPullServer"
            # PullServerServiceRoot        = "$env:PROGRAMFILES\WindowsPowerShell\DscService"

            # ComplianceServerEndPointName = 'PSDSCComplianceServer'
            # ComplianceServerPort         = 8081
            # ComplianceServerWebRoot      = "$env:SystemDrive\inetpub\wwwroot\PSDSCComplianceServer"
            # ComplianceServerThumbPrint   = 'AllowUnencryptedTraffic'

            # RegistrationKey              = ''
            # AdminAccounts                = @('[RRR]ServerAdmins', '[CC]ServerAdmins', '[RRR]SmaServiceAccount')
        }


    );
    CustomConfig = @(
        @{
            # FolderPath      = "f:\ConfigData"
            # FoldersRequired = @("MachineConfig.Current", "MachineConfig.Previous", "MachineData.Current", "MachineData.Previous", "TemplateData.Current", "TemplateData.Previous")
        }
    );

} 