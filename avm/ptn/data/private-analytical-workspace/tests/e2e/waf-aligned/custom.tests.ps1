param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate Pattern deployment' {

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

    Context 'Pattern Tests' {

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
            $r.ProvisioningState | Should -Be "Succeeded"
            $r.Name | Should -Be $name
            $r.Location | Should -Be $location
            $r.ResourceGroupName | Should -Be $resourceGroupName

            $r = Get-AzResource -ResourceId $virtualNetworkResourceId
            $r | Should -Not -BeNullOrEmpty
            $r.ProvisioningState | Should -Be "Succeeded"
            $r.Name | Should -Be $virtualNetworkName
            $r.Location | Should -Be $virtualNetworkLocation
            $r.ResourceGroupName | Should -Be $virtualNetworkResourceGroupName

            $r = Get-AzResource -ResourceId $logAnalyticsWorkspaceResourceId
            $r | Should -Not -BeNullOrEmpty
            $r.ProvisioningState | Should -Be "Succeeded"
            $r.Name | Should -Be $logAnalyticsWorkspaceName
            $r.Location | Should -Be $logAnalyticsWorkspaceLocation
            $r.ResourceGroupName | Should -Be $logAnalyticsWorkspaceResourceGroupName

            $r = Get-AzResource -ResourceId $keyVaultResourceId
            $r | Should -Not -BeNullOrEmpty
            $r.ProvisioningState | Should -Be "Succeeded"
            $r.Name | Should -Be $keyVaultName
            $r.Location | Should -Be $keyVaultLocation
            $r.ResourceGroupName | Should -Be $keyVaultResourceGroupName

            $r = Get-AzResource -ResourceId $databricksResourceId
            $r | Should -Not -BeNullOrEmpty
            $r.ProvisioningState | Should -Be "Succeeded"
            $r.Name | Should -Be $databricksName
            $r.Location | Should -Be $databricksLocation
            $r.ResourceGroupName | Should -Be $databricksResourceGroupName
        }

        Context 'Monitoring - Azure Log Analytics Workspace Tests' {

            BeforeAll {
            }

            It 'Check Azure Log Analytics Workspace' {

                $log = Get-AzOperationalInsightsWorkspace -ResourceGroupName $logAnalyticsWorkspaceResourceGroupName -name $logAnalyticsWorkspaceName
                $log | Should -Not -BeNullOrEmpty
                $log.ProvisioningState | Should -Be "Succeeded"
                $log.Sku | Should -Be 'PerGB2018'
                $log.RetentionInDays | Should -Be 35
                $log.WorkspaceCapping.DailyQuotaGb | Should -Be 1
                $log.WorkspaceCapping.DataIngestionStatus | Should -Be 'RespectQuota'
                $log.CapacityReservationLevel | Should -BeNullOrEmpty
                $log.PublicNetworkAccessForIngestion | Should -Be "Enabled"
                $log.PublicNetworkAccessForQuery | Should -Be "Enabled"
                $log.ForceCmkForQuery | Should -Be $true
                $log.PrivateLinkScopedResources | Should -BeNullOrEmpty
                $log.DefaultDataCollectionRuleResourceId | Should -BeNullOrEmpty
                $log.WorkspaceFeatures.EnableLogAccessUsingOnlyResourcePermissions | Should -Be $true
                $log.Tags.Owner | Should -Be "Contoso"
                $log.Tags.CostCenter | Should -Be "123-456-789"
                # TODO Role, Lock - How?
            }
        }

        Context 'Secrets - Azure Key Vault Tests' {

            BeforeAll {
            }

            It 'Check Azure Key Vault' {

                $kv = Get-AzKeyVault -ResourceGroupName $keyVaultResourceGroupName -VaultName $keyVaultName
                $kv | Should -Not -BeNullOrEmpty
                #$kv.ProvisioningState | Should -Be "Succeeded"     # Not available in the output
                $kv.Sku | Should -Be 'Standard'
                $kv.EnabledForDeployment | Should -Be $false
                $kv.EnabledForTemplateDeployment | Should -Be $false
                $kv.EnabledForDiskEncryption | Should -Be $false
                $kv.EnableRbacAuthorization | Should -Be $true
                $kv.EnableSoftDelete | Should -Be $true
                $kv.SoftDeleteRetentionInDays | Should -Be 90
                $kv.EnablePurgeProtection | Should -Be $true
                $kv.PublicNetworkAccess | Should -Be 'Disabled'
                $kv.AccessPolicies | Should -BeNullOrEmpty
                $kv.NetworkAcls.DefaultAction | Should -Be 'Deny'
                $kv.NetworkAcls.Bypass | Should -Be 'None'
                $kv.NetworkAcls.IpAddressRanges | Should -BeNullOrEmpty
                $kv.NetworkAcls.VirtualNetworkResourceIds | Should -BeNullOrEmpty
                $kv.Tags.Owner | Should -Be "Contoso"
                $kv.Tags.CostCenter | Should -Be "123-456-789"
                # TODO Role, Lock - How?

                $kvDiag  = Get-AzDiagnosticSetting -ResourceId $keyVaultResourceId -Name avm-diagnostic-settings
                $kvDiag | Should -Not -BeNullOrEmpty
                #$kvDiag.ProvisioningState | Should -Be "Succeeded"     # Not available in the output
                $kvDiag.Type | Should -Be "Microsoft.Insights/diagnosticSettings"
                $kvDiag.WorkspaceId | Should -Be $logAnalyticsWorkspaceResourceId

                $kvDiagCat = Get-AzDiagnosticSettingCategory -ResourceId $keyVaultResourceId
                $kvDiagCat | Should -Not -BeNullOrEmpty
                #$kvDiagCat.ProvisioningState | Should -Be "Succeeded"     # Not available in the output
                $kvDiagCat.Count | Should -Be 3 # AuditEvent, AzurePolicyEvaluationDetails, AllMetrics
                $kvDiagCat[0].Name | Should -BeIn @('AuditEvent', 'AzurePolicyEvaluationDetails', 'AllMetrics')
                $kvDiagCat[1].Name | Should -BeIn @('AuditEvent', 'AzurePolicyEvaluationDetails', 'AllMetrics')
                $kvDiagCat[2].Name | Should -BeIn @('AuditEvent', 'AzurePolicyEvaluationDetails', 'AllMetrics')

                $kvPEP = Get-AzPrivateEndpoint -ResourceGroupName $keyVaultResourceGroupName -Name "$($kv.VaultName)-PEP"
                $kvPEP | Should -Not -BeNullOrEmpty
                $kvPEP.ProvisioningState | Should -Be "Succeeded"
                $kvPEP.Subnet.Id | Should -Be "$($virtualNetworkResourceId)/subnets/private-link-subnet"
                $kvPEP.NetworkInterfaces.Count | Should -Be 1
                $kvPEP.PrivateLinkServiceConnections.ProvisioningState | Should -Be "Succeeded"
                $kvPEP.PrivateLinkServiceConnections.PrivateLinkServiceId | Should -Be $keyVaultResourceId
                $kvPEP.PrivateLinkServiceConnections.GroupIds.Count | Should -Be 1
                $kvPEP.PrivateLinkServiceConnections.GroupIds | Should -Be "vault"
                $kvPEP.PrivateLinkServiceConnections.PrivateLinkServiceConnectionState.Status | Should -Be "Approved"
                $kvPEP.Tag.Owner | Should -Be "Contoso"
                $kvPEP.Tag.CostCenter | Should -Be "123-456-789"
                # TODO Role, Lock - How?

                $kvZone = Get-AzPrivateDnsZone -ResourceGroupName $keyVaultResourceGroupName -Name "privatelink.vaultcore.azure.net"
                $kvZone | Should -Not -BeNullOrEmpty
                #$kvZone.ProvisioningState | Should -Be "Succeeded"
                $kvZone.NumberOfRecordSets | Should -Be 2 # SOA + A
                $kvZone.NumberOfVirtualNetworkLinks | Should -Be 1
                $kvZone.Tags.Owner | Should -Be "Contoso"
                $kvZone.Tags.CostCenter | Should -Be "123-456-789"
                # TODO Role, Lock - How?
            }
        }





        Context 'Azure Databricks Tests' {

            BeforeAll {
            }

            It 'Check Azure Databricks' {

                $adb = Get-AzDatabricksWorkspace -ResourceGroupName $databricksResourceGroupName -Name $databricksName
                $adb | Should -Not -BeNullOrEmpty
                $adb.ProvisioningState | Should -Be "Succeeded"
                $adb.CustomPrivateSubnetNameValue | Should -Be "dbw-backend-subnet"
                $adb.CustomPublicSubnetNameValue | Should -Be "dbw-frontend-subnet"
                $adb.CustomVirtualNetworkIdValue | Should -Be $virtualNetworkResourceId
                $adb.EnableNoPublicIP | Should -Be $true
                $adb.IsUcEnabled | Should -Be $true
                $adb.PublicNetworkAccess | Should -Be "Disabled"
                $adb.RequiredNsgRule | Should -Be "NoAzureDatabricksRules"
                $adb.SkuName | Should -Be "premium"
                $adb.Tags.Owner | Should -Be "Contoso"
                $adb.Tags.CostCenter | Should -Be "123-456-789"






                #PrivateEndpointConnection - json





                # TODO
                #role assignments, lock
                #$log | Format-List




                $adbZone = Get-AzPrivateDnsZone -ResourceGroupName $databricksResourceGroupName -Name "privatelink.azuredatabricks.net"
                $adbZone | Should -Not -BeNullOrEmpty
                $adbZone.ProvisioningState | Should -Be "Succeeded"
                $adbZone.NumberOfRecordSets | Should -Be 5 # SOA + 4xA
                $adbZone.NumberOfVirtualNetworkLinks | Should -Be 1
                $adbZone.Tag.Owner | Should -Be "Contoso"
                $adbZone.Tag.CostCenter | Should -Be "123-456-789"





                $adbAuthPEP = Get-AzPrivateEndpoint -ResourceGroupName $databricksResourceGroupName -Name "$($databricksName)-auth-PEP"
                $adbAuthPEP | Should -Not -BeNullOrEmpty
                $adbAuthPEP.ProvisioningState | Should -Be "Succeeded"
                # $adbAuthPEP TODO - do more checks

                $adbUiPEP = Get-AzPrivateEndpoint -ResourceGroupName $databricksResourceGroupName -Name "$($databricksName)-ui-PEP"
                $adbUiPEP | Should -Not -BeNullOrEmpty
                $adbUiPEP.ProvisioningState | Should -Be "Succeeded"
                # $adbUiPEP TODO - do more checks





            }
        }














        It 'Check Tags' {

            $tag1 = 'Owner'
            $tag1Val = 'Contoso'
            $tag2 = 'CostCenter'
            $tag2Val = '123-456-789'

            $t = Get-AzTag -ResourceId $resourceId
            $t.Properties.TagsProperty[$tag1] | Should -Be $tag1Val
            $t.Properties.TagsProperty[$tag2] | Should -Be $tag2Val

            $t = Get-AzTag -ResourceId $virtualNetworkResourceId
            $t.Properties.TagsProperty[$tag1] | Should -Be $tag1Val
            $t.Properties.TagsProperty[$tag2] | Should -Be $tag2Val

            # Existing log has different tags
            #$t = Get-AzTag -ResourceId $logAnalyticsWorkspaceResourceId
            #$t.Properties.TagsProperty[$tag1] | Should -Be $tag1Val
            #$t.Properties.TagsProperty[$tag2] | Should -Be $tag2Val

            $t = Get-AzTag -ResourceId $keyVaultResourceId
            $t.Properties.TagsProperty[$tag1] | Should -Be $tag1Val
            $t.Properties.TagsProperty[$tag2] | Should -Be $tag2Val

            $t = Get-AzTag -ResourceId $databricksResourceId
            $t.Properties.TagsProperty[$tag1] | Should -Be $tag1Val
            $t.Properties.TagsProperty[$tag2] | Should -Be $tag2Val
        }
    }






}
