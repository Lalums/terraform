resource "azurerm_template_deployment" {
  name                = "loganalyticsdeploy"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"
  depends_on = ["azurerm_resource_group.myresourcegroup"]
#Forces terrafrom to wait for specified time before timeout. used for resources which can take long time to complete
#currently not supported hence commented
   timeouts {
    #create = "2h"
    #delete = "60m"
  }

  template_body = <<DEPLOY
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "workSpaceName": {
            "type": "string",
            "defaultValue": "",
            "metadata": {
                "description": "workSpaceName"
            }
        },
        "serviceTier": {
            "type": "string",
            "allowedValues": [
                "Free",
                "Standalone",
                "PerNode"
            ],
            "metadata": {
                "description": "Service Tier: Free, Standalone, or PerNode"
            }
        },
        "automationAccountName":{
            "type": "string",
            "defaultValue": "",
            "metadata": {
                "description": "The name of the Automation Account"
            }        
        },
        "location": {
            "type": "string",
            "allowedValues": [
                "East US",
                "East US 2",
                "North Europe",
                "West Europe",
                "Southeast Asia",
                "Australia Southeast"
            ]
        },
        "automationLocation": {
            "type": "string",
            "allowedValues": [
                "East US 2",
                "West Europe",
                "Southeast Asia",
                "Australia Southeast"
            ],
            "metadata": {
                "description": "The Automation account is only available in certain regions: japaneast,eastus2,westeurope,southeastasia,southcentralus,brazilsouth,uksouth,westcentralus,northeurope,canadacentral,australiasoutheast,centralindia"
            }
        },
        "diagnosticStoreName":{
            "type": "string",
            "defaultValue": "",
            "metadata": {
                "description": "The name of the Diagnostic Storage Account, has to be all lowercase"
            }                
        },
        "bcdvomsdiagstoreType": {
            "type": "string",
            "defaultValue": "",
            "allowedValues": [
                "Standard_LRS",
                "Standard_ZRS",
                "Standard_GRS",
                "Standard_RAGRS",
                "Premium_LRS"
            ]
        }

    },
    "variables": {
        "omsSolutions": {
            "solutions": [{
                "name": "[concat('Security', '(', parameters('workSpaceName'), ')')]",
                "marketplaceName": "Security"
            }, {
                "name": "[concat('AgentHealthAssessment', '(', parameters('workSpaceName'), ')')]",
                "marketplaceName": "AgentHealthAssessment"
            }, {
                "name": "[concat('AzureAppGatewayAnalytics', '(', parameters('workSpaceName'), ')')]",
                "marketplaceName": "AzureAppGatewayAnalytics"
            }, {
                "name": "[concat('Updates', '(', parameters('workSpaceName'), ')')]",
                "marketplaceName": "Updates"
            }, {
                "name": "[concat('AzureActivity', '(', parameters('workSpaceName'), ')')]",
                "marketplaceName": "AzureActivity"
            }, {
                "name": "[concat('AzureAutomation', '(', parameters('workSpaceName'), ')')]",
                "marketplaceName": "AzureAutomation"
            }, {
                "name": "[concat('AzureNSGAnalytics', '(', parameters('workSpaceName'), ')')]",
                "marketplaceName": "AzureNSGAnalytics"
            }, {
                "name": "[concat('AzureSQLAnalytics', '(', parameters('workSpaceName'), ')')]",
                "marketplaceName": "AzureSQLAnalytics"
            }, {
                "name": "[concat('SecurityCenterFree', '(', parameters('workSpaceName'), ')')]",
                "marketplaceName": "SecurityCenterFree"
            }, {
                "name": "[concat('Containers', '(', parameters('workSpaceName'), ')')]",
                "marketplaceName": "Containers"
            }, {
                "name": "[concat('ChangeTracking', '(', parameters('workSpaceName'), ')')]",
                "marketplaceName": "ChangeTracking"
            }, {
                "name": "[concat('DnsAnalytics', '(', parameters('workSpaceName'), ')')]",
                "marketplaceName": "DnsAnalytics"
            }, {
                "name": "[concat('NetworkMonitoring', '(', parameters('workSpaceName'), ')')]",
                "marketplaceName": "NetworkMonitoring"
            }, {
                "name": "[concat('ApplicationInsights', '(', parameters('workSpaceName'), ')')]",
                "marketplaceName": "ApplicationInsights"
            }]
        },
        "bcdvomsdiagstoreName": "[toLower(parameters('diagnosticStoreName'))]",
        "automationAccountName": "[parameters('automationAccountName')]"
    },
    "resources": [{
            "type": "Microsoft.Storage/storageAccounts",
            "name": "[variables('bcdvomsdiagstoreName')]",
            "apiVersion": "2015-06-15",
            "location": "[resourceGroup().location]",
            "tags": {
                "displayName": "bcdvomsdiagstore"
            },
            "properties": {
                "accountType": "[parameters('bcdvomsdiagstoreType')]"
            }
        }, {
            "type": "Microsoft.Automation/automationAccounts",
            "name": "[variables('automationAccountName')]",
            "apiVersion": "2015-10-31",
            "properties": {
                "sku": {
                    "name": "Basic",
                    "capacity": 4
                }
            },
            "location": "[parameters('automationLocation')]",
            "tags": {}
        }, {
            "apiVersion": "2017-03-15-preview",
            "type": "Microsoft.OperationalInsights/workspaces",
            "name": "[parameters('workSpaceName')]",
            "location": "[parameters('location')]",
            "properties": {
                "sku": {
                    "Name": "[parameters('serviceTier')]"
                },
                "retention": 7
            },
            "resources": [{
                    "apiVersion": "2017-03-15-preview",
                    "name": "VMSS Queries2",
                    "type": "savedSearches",
                    "dependsOn": [
                        "[concat('Microsoft.OperationalInsights/workspaces/', parameters('workSpaceName'))]"
                    ],
                    "properties": {
                        "Category": "VMSS",
                        "ETag": "*",
                        "DisplayName": "VMSS Instance Count",
                        "Query": "Event | where Source == 'ServiceFabricNodeBootstrapAgent' | summarize AggregatedValue = count() by Computer",
                        "Version": 1
                    }
                }, {
                    "apiVersion": "2015-11-01-preview",
                    "type": "datasources",
                    "name": "sampleWindowsEvent1",
                    "dependsOn": [
                        "[concat('Microsoft.OperationalInsights/workspaces/', parameters('workSpaceName'))]"
                    ],
                    "kind": "WindowsEvent",
                    "properties": {
                        "eventLogName": "Application",
                        "eventTypes": [{
                            "eventType": "Error"
                        }, {
                            "eventType": "Warning"
                        }]
                    }
                }, {
                    "apiVersion": "2015-11-01-preview",
                    "type": "datasources",
                    "name": "sampleWindowsPerfCounter1",
                    "dependsOn": [
                        "[concat('Microsoft.OperationalInsights/workspaces/', parameters('workSpaceName'))]"
                    ],
                    "kind": "WindowsPerformanceCounter",
                    "properties": {
                        "objectName": "Memory",
                        "instanceName": "*",
                        "intervalSeconds": 10,
                        "counterName": "Available MBytes"
                    }
                }, {
                    "apiVersion": "2015-11-01-preview",
                    "type": "datasources",
                    "name": "sampleIISLog1",
                    "dependsOn": [
                        "[concat('Microsoft.OperationalInsights/workspaces/', parameters('workSpaceName'))]"
                    ],
                    "kind": "IISLogs",
                    "properties": {
                        "state": "OnPremiseEnabled"
                    }
                }, {
                    "apiVersion": "2015-11-01-preview",
                    "type": "datasources",
                    "name": "sampleSyslog1",
                    "dependsOn": [
                        "[concat('Microsoft.OperationalInsights/workspaces/', parameters('workSpaceName'))]"
                    ],
                    "kind": "LinuxSyslog",
                    "properties": {
                        "syslogName": "kern",
                        "syslogSeverities": [{
                            "severity": "emerg"
                        }, {
                            "severity": "alert"
                        }, {
                            "severity": "crit"
                        }, {
                            "severity": "err"
                        }, {
                            "severity": "warning"
                        }]
                    }
                }, {
                    "apiVersion": "2015-11-01-preview",
                    "type": "datasources",
                    "name": "sampleSyslogCollection1",
                    "dependsOn": [
                        "[concat('Microsoft.OperationalInsights/workspaces/', parameters('workSpaceName'))]"
                    ],
                    "kind": "LinuxSyslogCollection",
                    "properties": {
                        "state": "Enabled"
                    }
                }, {
                    "apiVersion": "2015-11-01-preview",
                    "type": "datasources",
                    "name": "sampleLinuxPerf1",
                    "dependsOn": [
                        "[concat('Microsoft.OperationalInsights/workspaces/', parameters('workSpaceName'))]"
                    ],
                    "kind": "LinuxPerformanceObject",
                    "properties": {
                        "performanceCounters": [{
                            "counterName": "% Used Inodes"
                        }, {
                            "counterName": "Free Megabytes"
                        }, {
                            "counterName": "% Used Space"
                        }, {
                            "counterName": "Disk Transfers/sec"
                        }, {
                            "counterName": "Disk Reads/sec"
                        }, {
                            "counterName": "Disk Writes/sec"
                        }],
                        "objectName": "Logical Disk",
                        "instanceName": "*",
                        "intervalSeconds": 10
                    }
                }, {
                    "apiVersion": "2015-11-01-preview",
                    "type": "datasources",
                    "name": "sampleLinuxPerfCollection1",
                    "dependsOn": [
                        "[concat('Microsoft.OperationalInsights/workspaces/', parameters('workSpaceName'))]"
                    ],
                    "kind": "LinuxPerformanceCollection",
                    "properties": {
                        "state": "Enabled"
                    }
                }, {
                    "apiVersion": "2015-11-01-preview",
                    "type": "datasources",
                    "name": "sampleCustomLog1",
                    "dependsOn": [
                        "[concat('Microsoft.OperationalInsights/workspaces/', parameters('workSpaceName'))]"
                    ],
                    "kind": "CustomLog",
                    "properties": {
                        "customLogName": "sampleCustomLog1",
                        "description": "test custom log datasources",
                        "inputs": [{
                            "location": {
                                "fileSystemLocations": {
                                    "windowsFileTypeLogPaths": [
                                        "e:\\iis5\\*.log"
                                    ],
                                    "linuxFileTypeLogPaths": [
                                        "/var/logs"
                                    ]
                                }
                            },
                            "recordDelimiter": {
                                "regexDelimiter": {
                                    "pattern": "\\n",
                                    "matchIndex": 0,
                                    "matchIndexSpecified": true,
                                    "numberedGroup": null
                                }
                            }
                        }],
                        "extractions": [{
                            "extractionName": "TimeGenerated",
                            "extractionType": "DateTime",
                            "extractionProperties": {
                                "dateTimeExtraction": {
                                    "regex": null,
                                    "joinStringRegex": null
                                }
                            }
                        }]
                    }
                }, {
                    "apiVersion": "2015-11-01-preview",
                    "type": "datasources",
                    "name": "sampleCustomLogCollection1",
                    "dependsOn": [
                        "[concat('Microsoft.OperationalInsights/workspaces/', parameters('workSpaceName'))]"
                    ],
                    "kind": "CustomLogCollection",
                    "properties": {
                        "state": "LinuxLogsEnabled"
                    }
                }, {
                    "apiVersion": "2015-11-01-preview",
                    "name": "[concat('diagnosticstore',parameters('workSpaceName'))]",
                    "type": "storageinsightconfigs",
                    "dependsOn": [
                        "[concat('Microsoft.OperationalInsights/workspaces/', parameters('workSpaceName'))]",
                        "[concat('Microsoft.Storage/storageAccounts/', variables('bcdvomsdiagstoreName'))]"
                    ],
                    "properties": {
                        "containers": [
                            "wad-iis-logfiles"
                        ],
                        "tables": [
                            "WADWindowsEventLogsTable"
                        ],
                        "storageAccount": {
                            "id": "[resourceId('Microsoft.Storage/storageAccounts/', variables('bcdvomsdiagstoreName'))]",
                            "key": "[listKeys(resourceId('Microsoft.Storage/storageAccounts/',variables('bcdvomsdiagstoreName')),'2015-06-15').key1]"
                        }
                    }
                }

            ]
        }, {
            "apiVersion": "2015-11-01-preview",
            "type": "Microsoft.OperationsManagement/solutions",
            "name": "[concat(variables('omsSolutions').solutions[copyIndex()].Name)]",
            "location": "[parameters('location')]",
            "dependsOn": [
                "[concat('Microsoft.OperationalInsights/workspaces/', parameters('workSpaceName'))]"
            ],
            "copy": {
                "name": "omsSolutionCopy",
                "count": "[length(variables('omsSolutions').solutions)]"
            },
            "properties": {
                "workspaceResourceId": "[resourceId('Microsoft.OperationalInsights/workspaces', parameters('workSpaceName'))]"
            },
            "plan": {
                "name": "[variables('omsSolutions').solutions[copyIndex()].name]",
                "product": "[concat('OMSGallery/', variables('omsSolutions').solutions[copyIndex()].marketplaceName)]",
                "promotionCode": "",
                "publisher": "Microsoft"
            }
        }

    ],
    "outputs": {
        "workSpaceName": {
            "type": "string",
            "value": "[parameters('workSpaceName')]"
        },
        "provisioningState": {
            "type": "string",
            "value": "[reference(resourceId('Microsoft.OperationalInsights/workspaces', parameters('workSpaceName')), '2015-11-01-preview').provisioningState]"
        },
        "source": {
            "type": "string",
            "value": "[reference(resourceId('Microsoft.OperationalInsights/workspaces', parameters('workSpaceName')), '2015-11-01-preview').source]"
        },
        "customerId": {
            "type": "string",
            "value": "[reference(resourceId('Microsoft.OperationalInsights/workspaces', parameters('workSpaceName')), '2015-11-01-preview').customerId]"
        },
        "pricingTier": {
            "type": "string",
            "value": "[reference(resourceId('Microsoft.OperationalInsights/workspaces', parameters('workSpaceName')), '2015-11-01-preview').sku.name]"
        },
        "retentionInDays": {
            "type": "int",
            "value": "[reference(resourceId('Microsoft.OperationalInsights/workspaces', parameters('workSpaceName')), '2015-11-01-preview').retentionInDays]"
        },
        "portalUrl": {
            "type": "string",
            "value": "[reference(resourceId('Microsoft.OperationalInsights/workspaces', parameters('workSpaceName')), '2015-11-01-preview').portalUrl]"
        }
    }
}

DEPLOY

  parameters {
    "workSpaceName"                     = "${var.omsworkspace}"
    "serviceTier"                       = "Free"
    "automationAccountName"             = "${var.autoaccname}"
    "location"                          = "West Europe"
    "automationLocation"                = "West Europe"
    "diagnosticStoreName"               =  "${element(var.sanames, 3)}"
    "bcdvomsdiagstoreType"              = "Standard_LRS"
  }

  deployment_mode = "Incremental"
}
