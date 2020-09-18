
#----------------------------------------------------------------------------#
# Create compute server instance with prometeus, blackbox and grafana        #
#----------------------------------------------------------------------------#
   
resource "google_compute_instance" "server" {
    name                        = var.name_server
    project                     = var.project
    machine_type                = var.machine_type
    zone                        = var.zone
    depends_on                  = [google_compute_instance.client]
    metadata = {
        ssh-keys                = "${var.ssh_user}:${var.ssh_key}"
    }
    boot_disk {
        initialize_params {
            type                = var.boot_disk_type
            size                = var.boot_disk_size
            image               = "${var.image_project}/${var.image_family}"
        }
    }
    metadata_startup_script     = file("startup.sh")
    network_interface {
        network                 = var.network
        subnetwork              = var.subnet_name
        network_ip              = var.network_ip
        access_config {
        }
    }
     
    tags                        = var.server_tags    

    service_account {
        email                   = var.service_account_email
        scopes                  = var.service_account_scopes
    }
}


#------------------------------------------------------------------------#
# Create compute client instance with prometheus agent and tomcat		 #
#------------------------------------------------------------------------#
   
resource "google_compute_instance" "client" {
    name                        = var.name_client
    project                     = var.project
    machine_type                = var.machine_type
    zone                        = var.zone
    metadata = {
        ssh-keys                = "${var.ssh_user}:${var.ssh_key}"
    }
    boot_disk {
        initialize_params {
            type                = var.boot_disk_type
            size                = var.boot_disk_size
            image               = "${var.image_project}/${var.image_family}"
        }
    }
    network_interface {
        network                 = var.network
        subnetwork              = var.subnet_name
        network_ip              = var.network_ip
        access_config {
        }
    }
    tags                        = var.client_tags    
    metadata_startup_script     = file("agent_tomcat_install.sh")

    service_account {
        email                   = var.service_account_email
        scopes                  = var.service_account_scopes
    }
}

    

    

