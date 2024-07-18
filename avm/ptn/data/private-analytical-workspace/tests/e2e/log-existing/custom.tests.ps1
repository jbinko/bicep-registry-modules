param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate deployment' {

    BeforeAll {
        $resourceId = $TestInputData.DeploymentOutputs.resourceId.Value
        $name = $TestInputData.DeploymentOutputs.name.Value
        $location = $TestInputData.DeploymentOutputs.location.Value
        $resourceGroupName = $TestInputData.DeploymentOutputs.resourceGroupName.Value

        $virtualNetworkResourceId = $TestInputData.DeploymentOutputs.virtualNetworkResourceId.Value
        $virtualNetworkName = $TestInputData.DeploymentOutputs.virtualNetworkName.Value
        $virtualNetworkLocation = $TestInputData.DeploymentOutputs.virtualNetworkLocation.Value
        $virtualNetworkResourceGroupName = $TestInputData.DeploymentOutputs.virtualNetworkResourceGroupName.Value

        $logAnalyticsWorkspaceResourceId = $TestInputData.DeploymentOutputs.logAnalyticsWorkspaceResourceId.Value
        $logAnalyticsWorkspaceName = $TestInputData.DeploymentOutputs.logAnalyticsWorkspaceName.Value
        $logAnalyticsWorkspaceLocation = $TestInputData.DeploymentOutputs.logAnalyticsWorkspaceLocation.Value
        $logAnalyticsWorkspaceResourceGroupName = $TestInputData.DeploymentOutputs.logAnalyticsWorkspaceResourceGroupName.Value

        $keyVaultResourceId = $TestInputData.DeploymentOutputs.keyVaultResourceId.Value
        $keyVaultName = $TestInputData.DeploymentOutputs.keyVaultName.Value
        $keyVaultLocation = $TestInputData.DeploymentOutputs.keyVaultLocation.Value
        $keyVaultResourceGroupName = $TestInputData.DeploymentOutputs.keyVaultResourceGroupName.Value

        $databricksResourceId = $TestInputData.DeploymentOutputs.databricksResourceId.Value
        $databricksName = $TestInputData.DeploymentOutputs.databricksName.Value
        $databricksLocation = $TestInputData.DeploymentOutputs.databricksLocation.Value
        $databricksResourceGroupName = $TestInputData.DeploymentOutputs.databricksResourceGroupName.Value
    }

    Context 'Common Tests' {

        BeforeAll {
        }

        It 'Check Output Variables' {

            $resourceId | Should -Not -BeNullOrEmpty
            $name | Should -Not -BeNullOrEmpty
            $location | Should -Not -BeNullOrEmpty
            $resourceGroupName | Should -Not -BeNullOrEmpty

            $virtualNetworkResourceId | Should -Not -BeNullOrEmpty
            $virtualNetworkName | Should -Not -BeNullOrEmpty
            $virtualNetworkLocation | Should -Not -BeNullOrEmpty
            $virtualNetworkResourceGroupName | Should -Not -BeNullOrEmpty

            $logAnalyticsWorkspaceResourceId | Should -Not -BeNullOrEmpty
            $logAnalyticsWorkspaceName | Should -Not -BeNullOrEmpty
            $logAnalyticsWorkspaceLocation | Should -Not -BeNullOrEmpty
            $logAnalyticsWorkspaceResourceGroupName | Should -Not -BeNullOrEmpty

            $keyVaultResourceId | Should -Not -BeNullOrEmpty
            $keyVaultName | Should -Not -BeNullOrEmpty
            $keyVaultLocation | Should -Not -BeNullOrEmpty
            $keyVaultResourceGroupName | Should -Not -BeNullOrEmpty

            $databricksResourceId | Should -Not -BeNullOrEmpty
            $databricksName | Should -Not -BeNullOrEmpty
            $databricksLocation | Should -Not -BeNullOrEmpty
            $databricksResourceGroupName | Should -Not -BeNullOrEmpty
        }

        It 'Check Mandatory Objects' {

            $r = Get-AzResource -ResourceId $resourceId
            $r | Should -Not -BeNullOrEmpty
            $r.Name | Should -Be $name
            $r.Location | Should -Be $location
            $r.ResourceGroupName | Should -Be $resourceGroupName

            $r = Get-AzResource -ResourceId $virtualNetworkResourceId
            $r | Should -Not -BeNullOrEmpty
            $r.Name | Should -Be $virtualNetworkName
            $r.Location | Should -Be $virtualNetworkLocation
            $r.ResourceGroupName | Should -Be $virtualNetworkResourceGroupName

            $r = Get-AzResource -ResourceId $logAnalyticsWorkspaceResourceId
            $r | Should -Not -BeNullOrEmpty
            $r.Name | Should -Be $logAnalyticsWorkspaceName
            $r.Location | Should -Be $logAnalyticsWorkspaceLocation
            $r.ResourceGroupName | Should -Be $logAnalyticsWorkspaceResourceGroupName

            $r = Get-AzResource -ResourceId $keyVaultResourceId
            $r | Should -Not -BeNullOrEmpty
            $r.Name | Should -Be $keyVaultName
            $r.Location | Should -Be $keyVaultLocation
            $r.ResourceGroupName | Should -Be $keyVaultResourceGroupName

            $r = Get-AzResource -ResourceId $databricksResourceId
            $r | Should -Not -BeNullOrEmpty
            $r.Name | Should -Be $databricksName
            $r.Location | Should -Be $databricksLocation
            $r.ResourceGroupName | Should -Be $databricksResourceGroupName
        }

        It 'Check Tags' {

            $tag1 = 'Environment'
            $tag1Val = 'Non-Prod'
            $tag2 = 'Role'
            $tag2Val = 'DeploymentValidation'

            $t = Get-AzTag -ResourceId $resourceId
            $t.Properties.TagsProperty[$tag1] | Should -Be $tag1Val
            $t.Properties.TagsProperty[$tag2] | Should -Be $tag2Val

            $t = Get-AzTag -ResourceId $virtualNetworkResourceId
            $t.Properties.TagsProperty[$tag1] | Should -Be $tag1Val
            $t.Properties.TagsProperty[$tag2] | Should -Be $tag2Val

            $t = Get-AzTag -ResourceId $logAnalyticsWorkspaceResourceId
            $t.Properties.TagsProperty[$tag1] | Should -Be $tag1Val
            $t.Properties.TagsProperty[$tag2] | Should -Be $tag2Val

            $t = Get-AzTag -ResourceId $keyVaultResourceId
            $t.Properties.TagsProperty[$tag1] | Should -Be $tag1Val
            $t.Properties.TagsProperty[$tag2] | Should -Be $tag2Val

            $t = Get-AzTag -ResourceId $databricksResourceId
            $t.Properties.TagsProperty[$tag1] | Should -Be $tag1Val
            $t.Properties.TagsProperty[$tag2] | Should -Be $tag2Val
        }
    }

    Context 'Monitoring - Azure Log Analytics Workspace Tests' {

        BeforeAll {
        }

        It 'Check Azure Log Analytics Workspace Defaults' {

            $log = Get-AzOperationalInsightsWorkspace -ResourceGroupName $logAnalyticsWorkspaceResourceGroupName -Name $logAnalyticsWorkspaceName

            $log.Sku | Should -Be 'PerGB2018'
            $log.RetentionInDays | Should -Be 53
            $log.WorkspaceCapping.DailyQuotaGb | Should -Be 22
            $log.WorkspaceCapping.DataIngestionStatus | Should -Be 'RespectQuota'
        }
    }

    Context 'Secrets - Azure Key Vault Tests' {

        BeforeAll {
        }

        It 'Check Azure Key Vault Defaults' {

            $kv = Get-AzKeyVault -ResourceGroupName $keyVaultResourceGroupName -VaultName $keyVaultName

            $kv.Sku | Should -Be 'Standard'

            $kv.EnabledForDeployment | Should -Be $false
            $kv.EnabledForTemplateDeployment | Should -Be $false
            $kv.EnabledForDiskEncryption | Should -Be $false

            $kv.EnabledForRBACAuthorization | Should -Be $true

            $kv.EnableSoftDelete | Should -Be $true
            $kv.SoftDeleteRetentionInDays | Should -Be 90
            $kv.EnablePurgeProtection | Should -Be $true

            $kv.PublicNetworkAccess | Should -Be 'Disabled'
            $kv.NetworkAcls.Bypass | Should -Be 'None'
            $kv.NetworkAcls.DefaultAction | Should -Be 'Deny'

            # TODO
            #$kv.NetworkAcls.IpAddressRanges  | Should -Be ''
            #diag settings
            #private links
            #role assignments
        }
    }
}
