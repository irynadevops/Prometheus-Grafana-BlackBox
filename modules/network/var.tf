
variable "project" {
    description 		= "The project in which the resource belongs. If it is not provided, the provider project is used."
    default     		= ""
}

variable "region" {
    description 		= "URL of the GCP region for this subnetwork."
    default     		= "us-central1"
}

variable "zone" {
    description 		= "URL of the GCP zone for bastion instance."
    default     		= "us-central1-b"
}

variable "name_network" {
    description 		= "Custom network."
    default 		    = "vpc-network"    
}

variable "auto_create_subnetworks" {
    description 		= "(Optional) If set to true, this network will be created in auto subnet mode, and Google will create a subnet for each region automatically. If set to false, a custom subnetted network will be created that can support google_compute_subnetwork resources. Defaults to true."
    default     		= "false"
}

variable "routing_mode" {
    description 		= "Sets the network-wide routing mode for Cloud Routers to use. Accepted values are 'GLOBAL' or 'REGIONAL'. Defaults to 'REGIONAL'. Refer to the Cloud Router documentation for more details."
    default     		= "REGIONAL"
}

variable "description" {
    description 		= "(Optional) A brief description of this resource."
    default     		= "Custom network."
}

variable "subnet_name" {
    description 		= "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
    default     		= "subnet"
}

variable "subnet_cidr" {
    description 			= "The client IP range od address to assign to the instance. If empty, the address will be automatically assigned."
    default     			= "10.5.2.0/24"
}

variable "enable_flow_logs" {
    description 		= "(Optional) Whether to enable flow logging for this subnetwork."
    default     		= "false"
}

variable "server_ip_google_access" {
    description 		= "(Optional) Whether the VMs in this subnet can access Google services without assigned external IP addresses."
    default     		= "false"
}

variable "client_ip_google_access" {
    description         = "(Optional) Whether the VMs in this subnet can access Google services without assigned external IP addresses."
    default             = "false"
}

variable "timeouts_create" {
    description         = "Time to create redis node. Default is 6 minutes. Valid units of time are s, m, h."
    default             = "1s"
}

variable "timeouts_update" {
    description         = "Time to update redis node. Default is 6 minutes. Valid units of time are s, m, h."
    default             = "1s"
}

variable "timeouts_delete" {
    description         = "Time to delete redis node. Default is 6 minutes. Valid units of time are s, m, h."
    default             = "1s"
}

variable "ssh_rule" {
    description         = "The firewall rules for ssh connection."
    default             = "ssh-rule"   
}

variable "priority_ssh" {
    description         = "The priority of this rule."
    default             = "1000"    
}

variable "description_ssh_rule" {
    default             = "It's create ssh access throuht bastion-host to server network."    
}

variable "direction" {
    description         = "This direction is allowed for all rules."
    default             = "INGRESS"    
}

variable "ssh_protocol" {
    description         = "Ssh protocol."
    default             = "tcp"    
}

variable "ssh_ports" {
    description         = "Ssh port."
    default             = ["22"]   
}

variable "allow_ssh_tags" {
    description         = "The destination of ssh connection."
    default             = ["client-tag","server-tag"]    
}

variable "ssh_tags" {
    description         = "The source of ssh connrction."
    default             = ["jump-tag"]    
}

variable "client_rule" {
    description         = "A name of rule for connection with client."
    default             = "client-rule"    
}

variable "jump_rules" {
    description         = "A name of rule."
    default             = "jump-rules"    
}

variable "priority_jump" {
    description         = "The priority of this rule."
    default             = "1000"    
}

variable "description_jump_rule" {
    default             = "It's create access to bastion host from any host."    
}

variable "jump_protocol" {
    description         = "Bastion protocol."
    default             = "tcp"    
}
variable "jump_port" {
    description         = "Bastion port."
    default             = ["22"]  
}

variable "jump_tag" {
    description         = "Bastion tag."
    default             = ["jump-tag"]   
}

variable "jump_ip" {
    description         = "IP range which can access to bastion host."
    default             = ["0.0.0.0/0"]    
}

variable "client_tcp_ports" {
    description         = "Tcp ports for datadogs, tomcat and http/https connetcion."
    default             = ["80","443","587","3000","5000","5001","5002","8080","9090","9093","9100","9115"] 
}

variable "client_udp_ports" {
    description         = "Udp ports for datadogs connetcion."
    default             = ["88","123","8125"] 
}

variable "deny_rule" {
    description         = "A name of rule."
    default             = "deny-rule"    
}

variable "priority_deny" {
    description         = "The priority of this rule."
    default             = "1001"    
}

variable "description_deny_rule" {
    default             = "It's make server access (deny all connection) throuht ssh connection if you try to access not throuht bastion host."    
}

variable "deny_protocol" {
    description         = "Deny protocol."
    default             = "tcp"    
}

variable "deny_port" {
    description         = "SSH port."
    default             = ["22"]    
}

variable "deny_tags" {
    description         = "Instanses with this tags has no access not throuht bastion host."
    default             = ["client-tag","server-tag"]    
}

variable "client_tag" {
  description           = "A tags of db host."
  default               = "client-tag"  
}

variable "server_tag" {
  description           = "A tags of db host."
  default               = "server-tag"  
}
