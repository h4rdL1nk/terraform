provider "openstack" {
  user_name   = "${var.ost-user}"
  password    = "${var.ost-password}"
  tenant_name = "jetsetme-test"
  auth_url    = "https://openstack-epg.hi.inet:13000/v2.0"
  region      = "regionOne"
  insecure    = "true"
}