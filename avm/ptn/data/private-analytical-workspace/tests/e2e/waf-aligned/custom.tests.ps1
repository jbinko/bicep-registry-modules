param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate Pattern deployment' {

    BeforeAll {

        . $PSScriptRoot/../../common.tests.ps1
        $expectedTags = @{Owner='Contoso'; CostCenter='123-456-789'; Err='Test'}

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

        Context 'Network - Azure Virtual Network Tests' {

            BeforeAll {
            }

            It 'Check Azure Virtual Network' {

                $vnet = Get-AzVirtualNetwork -ResourceGroupName $virtualNetworkResourceGroupName -Name $virtualNetworkName
                $vnet | Should -Not -BeNullOrEmpty
                $vnet.ProvisioningState | Should -Be "Succeeded"
                $vnet.AddressSpace.Count | Should -Be 1
                $vnet.AddressSpace[0].AddressPrefixes.Count | Should -Be 1
                $vnet.AddressSpace[0].AddressPrefixes[0] | Should -Be "192.168.224.0/19"
                $vnet.Subnets.Count | Should -Be 3

                $vnet.Subnets[0].ProvisioningState | Should -Be "Succeeded"
                $vnet.Subnets[0].Name | Should -Be "private-link-subnet"
                $vnet.Subnets[0].PrivateEndpointNetworkPolicies | Should -Be "Disabled"
                $vnet.Subnets[0].PrivateLinkServiceNetworkPolicies | Should -Be "Enabled"
                $vnet.Subnets[0].AddressPrefix.Count | Should -Be 1
                $vnet.Subnets[0].AddressPrefix[0] | Should -Be "192.168.224.0/24"
                $vnet.Subnets[0].NetworkSecurityGroup.Count | Should -Be 1
                $vnet.Subnets[0].PrivateEndpoints.Count | Should -Be 3  # 3x PEPs
                $vnet.Subnets[0].IpConfigurations.Count | Should -Be 5  # 5x IPs
                $vnet.Subnets[0].ServiceAssociationLinks | Should -BeNullOrEmpty
                $vnet.Subnets[0].ResourceNavigationLinks | Should -BeNullOrEmpty
                $vnet.Subnets[0].ServiceEndpoints | Should -BeNullOrEmpty
                $vnet.Subnets[0].ServiceEndpointPolicies | Should -BeNullOrEmpty
                $vnet.Subnets[0].Delegations | Should -BeNullOrEmpty
                $vnet.Subnets[0].IpAllocations | Should -BeNullOrEmpty
                $vnet.Subnets[0].RouteTable | Should -BeNullOrEmpty
                $vnet.Subnets[0].NatGateway | Should -BeNullOrEmpty
                $vnet.Subnets[0].DefaultOutboundAccess | Should -BeNullOrEmpty

                $vnet.Subnets[1].ProvisioningState | Should -Be "Succeeded"
                $vnet.Subnets[1].Name | Should -Be "dbw-frontend-subnet"
                $vnet.Subnets[1].PrivateEndpointNetworkPolicies | Should -Be "Disabled"
                $vnet.Subnets[1].PrivateLinkServiceNetworkPolicies | Should -Be "Enabled"
                $vnet.Subnets[1].AddressPrefix.Count | Should -Be 1
                $vnet.Subnets[1].AddressPrefix[0] | Should -Be "192.168.228.0/23"
                $vnet.Subnets[1].NetworkSecurityGroup.Count | Should -Be 1
                $vnet.Subnets[1].PrivateEndpoints | Should -BeNullOrEmpty
                $vnet.Subnets[1].IpConfigurations | Should -BeNullOrEmpty
                $vnet.Subnets[1].ServiceAssociationLinks | Should -BeNullOrEmpty
                $vnet.Subnets[1].ResourceNavigationLinks | Should -BeNullOrEmpty
                $vnet.Subnets[1].ServiceEndpoints | Should -BeNullOrEmpty
                $vnet.Subnets[1].ServiceEndpointPolicies | Should -BeNullOrEmpty
                $vnet.Subnets[1].Delegations.Count | Should -Be 1
                $vnet.Subnets[1].Delegations[0].ProvisioningState | Should -Be "Succeeded"
                $vnet.Subnets[1].Delegations[0].ServiceName | Should -Be "Microsoft.Databricks/workspaces"
                $vnet.Subnets[1].IpAllocations | Should -BeNullOrEmpty
                $vnet.Subnets[1].RouteTable | Should -BeNullOrEmpty
                $vnet.Subnets[1].NatGateway | Should -BeNullOrEmpty
                $vnet.Subnets[1].DefaultOutboundAccess | Should -BeNullOrEmpty

                $vnet.Subnets[2].ProvisioningState | Should -Be "Succeeded"
                $vnet.Subnets[2].Name | Should -Be "dbw-backend-subnet"
                $vnet.Subnets[2].PrivateEndpointNetworkPolicies | Should -Be "Disabled"
                $vnet.Subnets[2].PrivateLinkServiceNetworkPolicies | Should -Be "Enabled"
                $vnet.Subnets[2].AddressPrefix.Count | Should -Be 1
                $vnet.Subnets[2].AddressPrefix[0] | Should -Be "192.168.230.0/23"
                $vnet.Subnets[2].NetworkSecurityGroup.Count | Should -Be 1
                $vnet.Subnets[2].PrivateEndpoints | Should -BeNullOrEmpty
                $vnet.Subnets[2].IpConfigurations | Should -BeNullOrEmpty
                $vnet.Subnets[2].ServiceAssociationLinks | Should -BeNullOrEmpty
                $vnet.Subnets[2].ResourceNavigationLinks | Should -BeNullOrEmpty
                $vnet.Subnets[2].ServiceEndpoints | Should -BeNullOrEmpty
                $vnet.Subnets[2].ServiceEndpointPolicies | Should -BeNullOrEmpty
                $vnet.Subnets[2].Delegations.Count | Should -Be 1
                $vnet.Subnets[2].Delegations[0].ProvisioningState | Should -Be "Succeeded"
                $vnet.Subnets[2].Delegations[0].ServiceName | Should -Be "Microsoft.Databricks/workspaces"
                $vnet.Subnets[2].IpAllocations | Should -BeNullOrEmpty
                $vnet.Subnets[2].RouteTable | Should -BeNullOrEmpty
                $vnet.Subnets[2].NatGateway | Should -BeNullOrEmpty
                $vnet.Subnets[2].DefaultOutboundAccess | Should -BeNullOrEmpty

                $vnet.EnableDdosProtection | Should -Be $false
                $vnet.VirtualNetworkPeerings.Count | Should -Be 0
                $vnet.IpAllocations.Count | Should -Be 0
                $vnet.DhcpOptions.DnsServers | Should -BeNullOrEmpty
                $vnet.FlowTimeoutInMinutes | Should -BeNullOrEmpty
                $vnet.BgpCommunities | Should -BeNullOrEmpty
                $vnet.Encryption | Should -BeNullOrEmpty
                $vnet.DdosProtectionPlan | Should -BeNullOrEmpty
                $vnet.ExtendedLocation | Should -BeNullOrEmpty
                $vnet.Tag.Owner | Should -Be "Contoso"
                $vnet.Tag.CostCenter | Should -Be "123-456-789"
                # TODO Role, Lock - How?

                $logs = @('VMProtectionAlerts', 'AllMetrics')
                Test-VerifyDiagSettings -ResourceId $virtualNetworkResourceId -LogAnalyticsWorkspaceResourceId $logAnalyticsWorkspaceResourceId -Logs $logs

                $logs = @('NetworkSecurityGroupEvent', 'NetworkSecurityGroupRuleCounter')
                Test-VerifyNetworkSecurityGroup -NetworkSecurityGroupResourceId $vnet.Subnets[0].NetworkSecurityGroup[0].Id `
                    -Tags $expectedTags -VirtualNetworkResourceId $virtualNetworkResourceId -SubnetName "private-link-subnet" `
                    -NumberOfSecurityRules 1 -NumberOfDefaultSecurityRules 6 -LogAnalyticsWorkspaceResourceId $logAnalyticsWorkspaceResourceId -Logs $logs
                # TODO Role, Lock - How?
                # Do we have to check for specific rules?

                $logs = @('NetworkSecurityGroupEvent', 'NetworkSecurityGroupRuleCounter')
                Test-VerifyNetworkSecurityGroup -NetworkSecurityGroupResourceId $vnet.Subnets[1].NetworkSecurityGroup[0].Id `
                    -Tags $expectedTags -VirtualNetworkResourceId $virtualNetworkResourceId -SubnetName "dbw-frontend-subnet" `
                    -NumberOfSecurityRules 7 -NumberOfDefaultSecurityRules 6 -LogAnalyticsWorkspaceResourceId $logAnalyticsWorkspaceResourceId -Logs $logs
                # TODO Role, Lock - How?
                # Do we have to check for specific rules?

                $logs = @('NetworkSecurityGroupEvent', 'NetworkSecurityGroupRuleCounter')
                Test-VerifyNetworkSecurityGroup -NetworkSecurityGroupResourceId $vnet.Subnets[2].NetworkSecurityGroup[0].Id `
                    -Tags $expectedTags -VirtualNetworkResourceId $virtualNetworkResourceId -SubnetName "dbw-backend-subnet" `
                    -NumberOfSecurityRules 7 -NumberOfDefaultSecurityRules 6 -LogAnalyticsWorkspaceResourceId $logAnalyticsWorkspaceResourceId -Logs $logs
                # TODO Role, Lock - How?
                # Do we have to check for specific rules?
            }
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
                $log.WorkspaceFeatures.EnableLogAccessUsingOnlyResourcePermissions | Should -Be $false
                $log.Tags.Owner | Should -Be "Contoso"
                $log.Tags.CostCenter | Should -Be "123-456-789"
                # No DIAG for LAW
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

                $logs = @('AuditEvent', 'AzurePolicyEvaluationDetails', 'AllMetrics')
                Test-VerifyDiagSettings -ResourceId $keyVaultResourceId -LogAnalyticsWorkspaceResourceId $logAnalyticsWorkspaceResourceId -Logs $logs

                Test-VerifyPrivateEndpoint -Name "$($kv.VaultName)-PEP" -ResourceGroupName $keyVaultResourceGroupName -Tags $expectedTags -SubnetName "private-link-subnet" -ServiceId $keyVaultResourceId -GroupId "vault"
                # TODO Role, Lock - How?

                Test-VerifyDnsZone -Name "privatelink.vaultcore.azure.net" -ResourceGroupName $keyVaultResourceGroupName -Tags $expectedTags -NumberOfRecordSets 2 # SOA + A
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
                $adb.AccessConnectorId | Should -BeNullOrEmpty
                $adb.AccessConnectorIdentityType | Should -BeNullOrEmpty
                $adb.AccessConnectorUserAssignedIdentityId | Should -BeNullOrEmpty
                $adb.AmlWorkspaceIdType | Should -BeNullOrEmpty
                $adb.AmlWorkspaceIdValue | Should -BeNullOrEmpty
                #Skip $adb.Authorization
                $adb.AutomaticClusterUpdateValue | Should -BeNullOrEmpty
                $adb.ComplianceSecurityProfileComplianceStandard | Should -BeNullOrEmpty
                $adb.ComplianceSecurityProfileValue | Should -BeNullOrEmpty
                #Skip $adb.CreatedByApplicationId, $adb.CreatedByOid, $adb.CreatedByPuid, $adb.CreatedDateTime,
                $adb.CustomPrivateSubnetNameType | Should -Be "String"
                $adb.CustomPrivateSubnetNameValue | Should -Be "dbw-backend-subnet"
                $adb.CustomPublicSubnetNameType | Should -Be "String"
                $adb.CustomPublicSubnetNameValue | Should -Be "dbw-frontend-subnet"
                $adb.CustomVirtualNetworkIdType | Should -Be "String"
                $adb.CustomVirtualNetworkIdValue | Should -Be $virtualNetworkResourceId
                $adb.DefaultCatalogInitialName | Should -BeNullOrEmpty
                $adb.DefaultCatalogInitialType | Should -BeNullOrEmpty
                $adb.DefaultStorageFirewall | Should -BeNullOrEmpty
                $adb.DiskEncryptionSetId | Should -BeNullOrEmpty
                $adb.EnableNoPublicIP | Should -Be $true
                $adb.EnableNoPublicIPType | Should -Be "Bool"
                $adb.EncryptionKeyName | Should -BeNullOrEmpty
                $adb.EncryptionKeySource | Should -BeNullOrEmpty
                $adb.EncryptionKeyVaultUri | Should -BeNullOrEmpty
                $adb.EncryptionKeyVersion | Should -BeNullOrEmpty
                $adb.EncryptionType | Should -BeNullOrEmpty
                $adb.EnhancedSecurityMonitoringValue | Should -BeNullOrEmpty
                $adb.Id | Should -Be $databricksResourceId
                $adb.IsUcEnabled | Should -Be $true
                $adb.LoadBalancerBackendPoolNameType | Should -BeNullOrEmpty
                $adb.LoadBalancerBackendPoolNameValue | Should -BeNullOrEmpty
                $adb.LoadBalancerIdType | Should -BeNullOrEmpty
                $adb.LoadBalancerIdValue | Should -BeNullOrEmpty
                $adb.Location | Should -Be $databricksLocation
                $adb.ManagedDiskIdentityPrincipalId | Should -BeNullOrEmpty
                $adb.ManagedDiskIdentityTenantId | Should -BeNullOrEmpty
                $adb.ManagedDiskIdentityType | Should -BeNullOrEmpty
                $adb.ManagedDiskKeySource | Should -Be "Microsoft.Keyvault"
                $adb.ManagedDiskKeyVaultPropertiesKeyName | Should -BeNullOrEmpty
                $adb.ManagedDiskKeyVaultPropertiesKeyVaultUri | Should -BeNullOrEmpty
                $adb.ManagedDiskKeyVaultPropertiesKeyVersion | Should -BeNullOrEmpty
                $adb.ManagedDiskRotationToLatestKeyVersionEnabled | Should -BeNullOrEmpty
                #Skip $adb.ManagedResourceGroupId
                $adb.ManagedServiceKeySource | Should -Be "Microsoft.Keyvault"
                $adb.ManagedServicesKeyVaultPropertiesKeyName | Should -BeNullOrEmpty
                $adb.ManagedServicesKeyVaultPropertiesKeyVaultUri | Should -BeNullOrEmpty
                $adb.ManagedServicesKeyVaultPropertiesKeyVersion | Should -BeNullOrEmpty
                $adb.Name | Should -Be $databricksName
                $adb.NatGatewayNameType | Should -BeNullOrEmpty
                $adb.NatGatewayNameValue | Should -BeNullOrEmpty
                $adb.PrepareEncryption | Should -Be $true
                $adb.PrepareEncryptionType | Should -Be "Bool"
                $adb.PrivateEndpointConnection.Count | Should -Be 2

                $adb.PrivateEndpointConnection[0].GroupId.Count | Should -Be 1
                $adb.PrivateEndpointConnection[0].GroupId[0] | Should -Be "databricks_ui_api"
                $adb.PrivateEndpointConnection[0].PrivateLinkServiceConnectionStateStatus | Should -Be "Approved"
                $adb.PrivateEndpointConnection[0].ProvisioningState | Should -Be "Succeeded"

                $adb.PrivateEndpointConnection[1].GroupId.Count | Should -Be 1
                $adb.PrivateEndpointConnection[1].GroupId[0] | Should -Be "browser_authentication"
                $adb.PrivateEndpointConnection[1].PrivateLinkServiceConnectionStateStatus | Should -Be "Approved"
                $adb.PrivateEndpointConnection[1].ProvisioningState | Should -Be "Succeeded"

                $adb.PublicIPNameType | Should -Be "String"
                $adb.PublicIPNameValue | Should -Be "nat-gw-public-ip"
                $adb.PublicNetworkAccess | Should -Be "Disabled"
                $adb.RequireInfrastructureEncryption | Should -Be $false
                $adb.RequireInfrastructureEncryptionType | Should -Be "Bool"
                $adb.RequiredNsgRule | Should -Be "NoAzureDatabricksRules"
                $adb.ResourceGroupName | Should -Be $databricksResourceGroupName
                #Skip $adb.ResourceTagType, $adb.ResourceTagValue
                $adb.SkuName | Should -Be "premium"
                $adb.SkuTier | Should -BeNullOrEmpty
                #Skip $adb.StorageAccount**
                #Skip $adb.SystemData**
                $adb.Type | Should -Be "Microsoft.Databricks/workspaces"
                $adb.UiDefinitionUri | Should -BeNullOrEmpty
                #Skip $adb.UpdatedBy**
                #Skip $adb.Url
                $adb.VnetAddressPrefixType | Should -Be "String"
                $adb.VnetAddressPrefixValue | Should -Be "10.139"
                #Skip $adb.WorkspaceId
                Test-VerifyTagsForResource -ResourceId $adb.Id -Tags $expectedTags
                # TODO Role, Lock - How?


                $logs = @(
                    'dbfs', 'clusters', 'accounts', 'jobs', 'notebook',
                    'ssh', 'workspace', 'secrets', 'sqlPermissions', 'instancePools',
                    'sqlanalytics', 'genie', 'globalInitScripts', 'iamRole', 'mlflowExperiment',
                    'featureStore', 'RemoteHistoryService', 'mlflowAcledArtifact', 'databrickssql', 'deltaPipelines',
                    'modelRegistry', 'repos', 'unityCatalog', 'gitCredentials', 'webTerminal',
                    'serverlessRealTimeInference', 'clusterLibraries', 'partnerHub', 'clamAVScan', 'capsule8Dataplane',
                    'BrickStoreHttpGateway', 'Dashboards', 'CloudStorageMetadata', 'PredictiveOptimization', 'DataMonitoring',
                    'Ingestion', 'MarketplaceConsumer', 'LineageTracking'
                    )
                Test-VerifyDiagSettings -ResourceId $databricksResourceId -LogAnalyticsWorkspaceResourceId $logAnalyticsWorkspaceResourceId -Logs $logs

                Test-VerifyPrivateEndpoint -Name "$($databricksName)-auth-PEP" -ResourceGroupName $databricksResourceGroupName -Tags $expectedTags -SubnetName "private-link-subnet" -ServiceId $databricksResourceId -GroupId "browser_authentication"
                # TODO Role, Lock - How?

                Test-VerifyPrivateEndpoint -Name "$($databricksName)-ui-PEP" -ResourceGroupName $databricksResourceGroupName -Tags $expectedTags -SubnetName "private-link-subnet" -ServiceId $databricksResourceId -GroupId "databricks_ui_api"
                # TODO Role, Lock - How?

                Test-VerifyDnsZone -Name "privatelink.azuredatabricks.net" -ResourceGroupName $databricksResourceGroupName -Tags $expectedTags -NumberOfRecordSets 5 # SOA + 4xA
                # TODO Role, Lock - How?








                #KV pubacc, ACL pub ip
                #$log | Format-List

                #kvIpRules
                #dbwIpRules


            }
        }
    }
}
