variable "port" {
    description             = "A port of the email allerts."
    default                 = "587"
}

variable "email" {
    description             = "A redirect email for the allerts."
    default                 = ""
}

variable "to_email" {
    description             = "A destintion email for the allerts."
    default                 = ""
}

variable "server_external_ip" {
    default = ""
}

variable "password"{
    description             = "A password of the email box."
    default                 = ""
}

variable "name_client" {
    description             = "A name of the instance."
    default                 = "client-host"
}

variable "name_server" {
    description             = "A name of the instance."
    default                 = "server-host"
}

variable "region" {
  description 				= "A region for all instances in this project."
  default     				= "us-central1"
}

variable "zone" {
  description               = "A region for this instance in this project."
  default                   = "us-central1-b"
}

variable "project" {
    description 			= "The name of the project."
    default     			= ""
}

variable "ssh_user" {
    description 			= "User for connection to google machine"
    default     			= ""
}

variable "ssh_key" {
    description 			= "The ssh public key"
    default     			= ""
}

variable "network" {
    description 			= "The name of the server network."
    default     			= "vpc-network"
}

variable "network_ip" {
    description 		    = "Internal ip of the host."
    default 		        = ""    
}

variable "static_external_ip" {
    description 		    = "Internal external ip."
    default 		        = ""    
}

variable "static_internal_ip" {
    description 		    = "Internal internal ip."
    default 		        = ""    
}

variable "subnet_name" {
    description 		    = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
    default     		    = "subnet"
}

variable "service_account_email" {
    description 			= "The service account e-mail address. If not given, the default Google Compute Engine service account is used. Note: allow_stopping_for_update must be set to true in order to update this field."
    default     			= ""
}

variable "service_account_scopes" {
    description 			= "A list of service scopes. Both OAuth2 URLs and gcloud short names are supported. To allow full access to all Cloud APIs, use the cloud-platform scope. Note: allow_stopping_for_update must be set to true in order to update this field."
    default     			= []
}

variable "machine_type" {
    description 			= "The machine type to create.To create a machine with a custom type (such as extended memory), format the value like custom-VCPUS-MEM_IN_MB like custom-6-20480 for 6 vCPU and 20GB of RAM."
    default     			= "n1-standard-1"
}

variable "image_project" {
    description 			= "The project of image from which to initialize this disk. "
    default     			= "centos-cloud"
}

variable "image_family" {
    description 			= "The family of image from which to initialize this disk."
    default     			= "centos-7"
}


variable "boot_disk_type" {
    description 			= "The GCE disk type. Can be either 'pd-ssd', 'local-ssd', or 'pd-standard'."
    default     			= "pd-ssd"
}

variable "boot_disk_size" {
    description 			= "The size of the image in gigabytes. If not specified, it will inherit the size of its base image."
    default     			= "35"
}

variable "client_tags" {
  description               = "A tags of client host."
  default                   = ["client-tag","http-server","https-server"]    
}

variable "server_tags" {
  description               = "A tags of server host."
  default                   = ["server-tag","http-server","https-server"]    
}

variable "scheduling_preemptible" {
    description 			= "Is the instance preemptible."
    default     			= "false"
}

variable "scheduling_on_host_maintenance" {
    description 			= "Describes maintenance behavior for the instance. Can be MIGRATE or TERMINATE"
    default     			= "MIGRATE"
}

variable "scheduling_automatic_restart" {
    description 			= "Specifies if the instance should be restarted if it was terminated by Compute Engine (not a user)."
    default     			= "true"
}


            
