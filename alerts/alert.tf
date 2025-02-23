#### AKS Alerts ####

resource "azurerm_monitor_action_group" "actgrp" {
  name                = "CriticalAlertsAction"
  resource_group_name = var.aksrgname.name
  short_name          = "alerts"
    email_receiver {
    name                    = "sendtoaksteam"
    email_address           = "harsha.devops9989@gmail.com"
    use_common_alert_schema = true
  }
}

#################################
#### Average container cpu % ####
#################################
resource "azurerm_monitor_metric_alert" "alert_aks-container-cpu-percentage" {
  # #count               = var.AKSAlertContainerCPUPercentageCreated == true ? 1 : 0
  name                = "AKS_Container_CPU_Percentage-"
  resource_group_name = var.aksrgname.name 
  scopes              = ["/subscriptions/${var.subid}/resourceGroups/${var.aksrgname.name}/providers/Microsoft.ContainerService/managedClusters/${var.aksclustername}"]
  description         = "${var.aksclustername} Container CPU Percentage -"
  severity            = 3 #var.AKSAlertContainerCPUPercentageSeverity
  enabled             = true #var.AKSAlertContainerCPUPercentageEnabled
  frequency           = "PT1M" #var.AKSAlertContainerCPUPercentageFrequency
  # window_size         = coalesce(var.AKSAlertContainerCPUPercentageWindow, var.AKSAlertContainerCPUPercentageFrequency)
  auto_mitigate       = true #var.AKSAlertContainerCPUPercentageAutoResolve
  
  criteria {
    metric_namespace = "Insights.Container/containers"
    metric_name      = "cpuExceededPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 95 #var.AKSAlertContainerCPUPercentageThreshold

    dimension {
      name     = "kubernetes namespace"
      operator = "Include"
      values   = ["*"] #var.AKSAlertContainerCPUPercentageNameSpaces
    }

    dimension {
        name     = "controllerName"
        operator = "Include"
        values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.actgrp.id
  }

  tags  = local.tags
}
####################################
#### Average container memory % ####
####################################

resource "azurerm_monitor_metric_alert" "alert_aks-container-memory-percentage" {
  ##count               = var.AKSAlertContainerMemoryPercentageCreated == true ? 1 : 0
  name                = "AKS_Container_Memory_Percentage"
  resource_group_name = var.aksrgname.name
  scopes              = ["/subscriptions/${var.subid}/resourceGroups/${var.aksrgname.name}/providers/Microsoft.ContainerService/managedClusters/${var.aksclustername}"]
  description         = "${var.aksclustername} Container Memory Percentage"
  severity            = 3 
  enabled             = true 
  frequency           = "PT1M" 
  # window_size         = coalesce(var.AKSAlertContainerCPUPercentageWindow, var.AKSAlertContainerCPUPercentageFrequency)
  auto_mitigate       = true 
  
  criteria {
    metric_namespace = "Insights.Container/containers"
    metric_name      = "memoryWorkingSetExceededPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 95
    dimension {
      name     = "kubernetes namespace"
      operator = "Include"
      values   = ["*"]
    }

    dimension {
      name     = "controllerName"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.actgrp.id
  }
  tags  = local.tags
}

############################
#### Average node cpu % ####
############################

resource "azurerm_monitor_metric_alert" "alert_aks-node-cpu-percentage" {
  ##count               = var.AKSAlertNodeCPUPercentageCreated == true ? 1 : 0
  name                = "AKS_Node_CPU_Percentage"
  resource_group_name = var.aksrgname.name
  scopes              = ["/subscriptions/${var.subid}/resourceGroups/${var.aksrgname.name}/providers/Microsoft.ContainerService/managedClusters/${var.aksclustername}"]
  description         = "${var.aksclustername} Node CPU Percentage"
  severity            = 3 
  enabled             = true 
  frequency           = "PT1M" 
  # window_size         = coalesce(var.AKSAlertContainerCPUPercentageWindow, var.AKSAlertContainerCPUPercentageFrequency)
  auto_mitigate       = true 
  
  criteria {
    metric_namespace = "Insights.Container/nodes"
    metric_name      = "cpuUsagePercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 95

    dimension {
      name     = "host"
      operator = "Include"
      values   = ["*"]
    }    
  }

  action {
    action_group_id = azurerm_monitor_action_group.actgrp.id
  }

  tags  = local.tags
}

###############################
#### Average node memory % ####
###############################

resource "azurerm_monitor_metric_alert" "alert_aks-node-memory-percentage" {
  ##count               = var.AKSAlertNodeMemoryPercentageCreated == true ? 1 : 0
  name                = "AKS_Node_Memory_Percentage"
  resource_group_name = var.aksrgname.name
  scopes              = ["/subscriptions/${var.subid}/resourceGroups/${var.aksrgname.name}/providers/Microsoft.ContainerService/managedClusters/${var.aksclustername}"]
  description         = "${var.aksrgname} Node Memory Percentage"
  severity            = 3 
  enabled             = true 
  frequency           = "PT1M" 
  # window_size         = coalesce(var.AKSAlertContainerCPUPercentageWindow, var.AKSAlertContainerCPUPercentageFrequency)
  auto_mitigate       = true 
  
  criteria {
    metric_namespace = "Insights.Container/nodes"
    metric_name      = "memoryWorkingSetPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80

    dimension {
      name     = "host"
      operator = "Include"
      values   = ["*"]
    }
  }
    
  action {
    action_group_id = azurerm_monitor_action_group.actgrp.id
  }

  tags  = local.tags
}

#############################
#### Average node disk % ####
#############################

resource "azurerm_monitor_metric_alert" "alert_aks-node-disk-usage-percentage" {
  name                = "AKS_Node_Disk_Percentage"
  resource_group_name = var.aksrgname.name
  scopes              = ["/subscriptions/${var.subid}/resourceGroups/${var.aksrgname.name}/providers/Microsoft.ContainerService/managedClusters/${var.aksclustername}"]
  description         = "${var.aksclustername} Node Disk Percentage"
  severity            = 3 
  enabled             = true 
  frequency           = "PT1M" 
  # window_size         = coalesce(var.AKSAlertContainerCPUPercentageWindow, var.AKSAlertContainerCPUPercentageFrequency)
  auto_mitigate       = true 
  
  criteria {
    metric_namespace = "Insights.Container/nodes"
    metric_name      = "DiskUsedPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80

    dimension {
      name     = "host"
      operator = "Include"
      values   = ["*"]
    }

    dimension {
      name     = "device"
      operator = "Include"
      values   = ["*"]
    }
  }
    
  action {
    action_group_id = azurerm_monitor_action_group.actgrp.id
  }

  tags  = local.tags
}
#####################################
#### Average persistent volume % ####
#####################################

resource "azurerm_monitor_metric_alert" "alert_aks-pv-percentage" {
  #count               = var.AKSAlertPVPercentageCreated == true ? 1 : 0
  name                = "AKS_PV_Percentage"
  resource_group_name = var.aksrgname.name
  scopes              = ["/subscriptions/${var.subid}/resourceGroups/${var.aksrgname.name}/providers/Microsoft.ContainerService/managedClusters/${var.aksclustername}"]
  description         = "${var.aksclustername} Persistent Volume Percentage "
  severity            = 3 
  enabled             = true 
  frequency           = "PT1M" 
  # window_size         = coalesce(var.AKSAlertContainerCPUPercentageWindow, var.AKSAlertContainerCPUPercentageFrequency)
  auto_mitigate       = true
  
  criteria {
    metric_namespace = "Insights.Container/persistentvolumes"
    metric_name      = "pvUsageExceededPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 95

    dimension {
      name     = "podName"
      operator = "Include"
      values   = ["*"]
    }
  }
    
  action {
    action_group_id = azurerm_monitor_action_group.actgrp.id
  }

  tags  = local.tags
}

####################################
#### Restarting container #count ####
####################################

resource "azurerm_monitor_metric_alert" "alert_aks-restarting-container-#count" {
  #count               = var.AKSAlertRestartingContainer#countCreated == true ? 1 : 0
  name                = "AKS_Restarting_Container_#count"
  resource_group_name = var.aksrgname.name
  scopes              = ["/subscriptions/${var.subid}/resourceGroups/${var.aksrgname.name}/providers/Microsoft.ContainerService/managedClusters/${var.aksclustername}"]
  description         = "${var.aksclustername} Restarting Container #count "
  severity            = 3 
  enabled             = true 
  frequency           = "PT1M" 
  # window_size         = coalesce(var.AKSAlertContainerCPUPercentageWindow, var.AKSAlertContainerCPUPercentageFrequency)
  auto_mitigate       = true
  
  criteria {
    metric_namespace = "Insights.Container/pods"
    metric_name      = "restartingContainercount"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 0

    dimension {
      name     = "kubernetes namespace"
      operator = "Include"
      values   = ["*"]
    }

    dimension {
      name     = "controllerName"
      operator = "Include"
      values   = ["*"]
    }
  }
    
  action {
    action_group_id = azurerm_monitor_action_group.actgrp.id
  }

  tags  = local.tags
}

##########################
#### Failed pod #count ####
##########################

resource "azurerm_monitor_metric_alert" "alert_aks-pods-in-failed-state" {
  #count               = var.AKSAlertPodsInFailedStateCreated == true ? 1 : 0
  name                = "AKS_Pods_In_Failed_State"
  resource_group_name = var.aksrgname.name
  scopes              = ["/subscriptions/${var.subid}/resourceGroups/${var.aksrgname.name}/providers/Microsoft.ContainerService/managedClusters/${var.aksclustername}"]
  description         = "${var.aksclustername} Pods In Failed State "
  severity            = 3 
  enabled             = true 
  frequency           = "PT1M" 
  # window_size         = coalesce(var.AKSAlertContainerCPUPercentageWindow, var.AKSAlertContainerCPUPercentageFrequency)
  auto_mitigate       = true
  
  criteria {
    metric_namespace = "Insights.Container/pods"
    metric_name      = "podcount"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 0

    dimension {
      name     = "kubernetes namespace"
      operator = "Include"
      values   = ["*"]
    }

    dimension {
      name     = "controllerName"
      operator = "Include"
      values   = ["*"]
    }

    dimension {
      name     = "phase"
      operator = "Include"
      values   = ["Failed", "Unknown"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.actgrp.id
  }

  tags  = local.tags
}

########################
#### Node not ready ####
########################

resource "azurerm_monitor_metric_alert" "alert_aks-node-not-ready" {
  #count               = var.AKSAlertNodeNotReadyCreated == true ? 1 : 0
  name                = "AKS_Node_Not_Ready"
  resource_group_name = var.aksrgname.name
  scopes              = ["/subscriptions/${var.subid}/resourceGroups/${var.aksrgname.name}/providers/Microsoft.ContainerService/managedClusters/${var.aksclustername}"]
  description         = "${var.aksclustername} Node Not Ready "
  severity            = 3 
  enabled             = true 
  frequency           = "PT1M" 
  # window_size         = coalesce(var.AKSAlertContainerCPUPercentageWindow, var.AKSAlertContainerCPUPercentageFrequency)
  auto_mitigate       = true
  
  criteria {
    metric_namespace = "Insights.Container/nodes"
    metric_name      = "nodescount"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 0

    dimension {
      name     = "status"
      operator = "Include"
      values   = ["NotReady"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.actgrp.id
  }

  tags  = local.tags
}

###############################
#### OOM killed containers ####
###############################

resource "azurerm_monitor_metric_alert" "alert_aks-oom-killed-containers" {
  #count               = var.AKSAlertOOMKilledContainersCreated == true ? 1 : 0
  name                = "AKS_OOM_Killed_Containers"
  resource_group_name = var.aksrgname.name
  scopes              = ["/subscriptions/${var.subid}/resourceGroups/${var.aksrgname.name}/providers/Microsoft.ContainerService/managedClusters/${var.aksclustername}"]
  description         = "${var.aksclustername} OOM Killed Containers "
  severity            = 3 
  enabled             = true 
  frequency           = "PT1M" 
  # window_size         = coalesce(var.AKSAlertContainerCPUPercentageWindow, var.AKSAlertContainerCPUPercentageFrequency)
  auto_mitigate       = true
 
  criteria {
    metric_namespace = "Insights.Container/pods"
    metric_name      = "oomKilledContainer#count"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 0

    dimension {     
      name     = "kubernetes namespace"
      operator = "Include"
      values   = ["*"]
    }

    dimension {
        name     = "controllerName"
        operator = "Include"
        values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.actgrp.id
  }

  tags  = local.tags
}

######################
#### Pods ready % ####
######################

resource "azurerm_monitor_metric_alert" "alert_aks-pods-ready-percentage" {
  #count               = var.AKSAlertPodsReadyPercentageCreated == true ? 1 : 0
  name                = "AKS_Pods_Ready_Percentage"
  resource_group_name = var.aksrgname.name 
  scopes              = ["/subscriptions/${var.subid}/resourceGroups/${var.aksrgname.name}/providers/Microsoft.ContainerService/managedClusters/${var.aksclustername}"]
  description         = "${var.aksclustername} Container CPU Percentage "
  severity            = 3 
  enabled             = true 
  frequency           = "PT1M" 
  # window_size         = coalesce(var.AKSAlertContainerCPUPercentageWindow, var.AKSAlertContainerCPUPercentageFrequency)
  auto_mitigate       = true
  
  criteria {
    metric_namespace = "Insights.Container/pods"
    metric_name      = "PodReadyPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 95

    dimension {
      name     = "kubernetes namespace"
      operator = "Include"
      values   = ["*"]
    }

    dimension {
        name     = "controllerName"
        operator = "Include"
        values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.actgrp.id
  }

  tags  = local.tags
}

##########################
#### Stale jobs #count ####
##########################

resource "azurerm_monitor_metric_alert" "alert_aks-stale-jobs-#count" {
  #count               = var.AKSAlertPodsInFailedStateCreated == true ? 1 : 0
  name                = "AKS_Stale_Jobs_count"
  resource_group_name = var.aksrgname.name
  scopes              = ["/subscriptions/${var.subid}/resourceGroups/${var.aksrgname.name}/providers/Microsoft.ContainerService/managedClusters/${var.aksclustername}"]
  description         = "${var.aksclustername} Stale Jobs #count "
  severity            = 3 
  enabled             = true 
  frequency           = "PT1M" 
  # window_size         = coalesce(var.AKSAlertContainerCPUPercentageWindow, var.AKSAlertContainerCPUPercentageFrequency)
  auto_mitigate       = true
  
  criteria {
    metric_namespace = "Insights.Container/pods"
    metric_name      = "completedJobscount"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 0

    dimension {
      name     = "kubernetes namespace"
      operator = "Include"
      values   = ["*"]
    }

    dimension {
      name     = "controllerName"
      operator = "Include"
      values   = ["*"]
    }    
  }

  action {
    action_group_id = azurerm_monitor_action_group.actgrp.id
  }

  tags  = local.tags
}