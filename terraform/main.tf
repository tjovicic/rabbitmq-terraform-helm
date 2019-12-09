provider "google" {
  credentials = "${file("credentials.json")}"
  project     = "${var.project_name}"
  region      = "${var.region}"
}

provider "google-beta" {
  credentials = "${file("credentials.json")}"
  project     = "${var.project_name}"
  region      = "${var.region}"
}

data "google_container_engine_versions" "default" {
  location = "${var.region}"
  version_prefix = "${var.cluster_version_prefix}"
}

resource "google_container_cluster" "default" {
  provider = "google-beta"

  name = "${var.cluster}"
  location = "${var.region}"

  remove_default_node_pool = true
  initial_node_count = 1

  node_version = "${data.google_container_engine_versions.default.latest_node_version}"
  min_master_version = "${data.google_container_engine_versions.default.latest_node_version}"

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  network = "${var.network}"

  addons_config {
    kubernetes_dashboard {
      disabled = true
    }

    istio_config {
      disabled = false
      auth = "AUTH_MUTUAL_TLS"
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "07:00"
    }
  }
}

resource "google_container_node_pool" "default" {
  name = "${var.cluster_node_pool}"
  location = "${var.region}"
  cluster = "${google_container_cluster.default.name}"
  version = "${data.google_container_engine_versions.default.latest_node_version}"
  node_count = "${var.cluster_initial_node_count}"

  node_config {
    disk_size_gb = "${var.node_disk_size_gb}"
    disk_type = "${var.node_disk_type}"
    machine_type = "${var.node_machine_type}"
    image_type = "${var.node_image_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  management {
    auto_repair = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = "${var.node_pool_min_node_count}"
    max_node_count = "${var.node_pool_max_node_count}"
  }
}

