provider "openstack" {
  user_name   = "lmsm510"
  tenant_name = "jetsetme-test"
  password    = "${var.ost-password}"
  auth_url    = "https://openstack-epg.hi.inet:13000/v2.0"
  region      = "regionOne"
  insecure    = "true"
}
