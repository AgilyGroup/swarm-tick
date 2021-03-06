provider "google" {
// https://github.com/hashicorp/terraform/issues/16641
//  version     = "1.18.0"
  credentials = "${file("account.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}

resource "google_compute_firewall" "tick" {
  name    = "${terraform.workspace}-tick"
  network = "${var.swarm_name}"

  allow {
    protocol = "tcp"
    ports    = ["8888"]
  }

  source_ranges = ["${var.management_ip_range}"]
  target_tags   = ["swarm"]
}

resource "null_resource" "deploy" {
  provisioner "local-exec" {
    command = "DOCKER_HOST=${var.docker_host} docker stack deploy --compose-file docker-compose.yml tick"
    working_dir = "${path.module}"
  }
}