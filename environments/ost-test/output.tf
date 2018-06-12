output "instance-ips" {
  value = ["${module.docker-pool-instances.instance-ssh-ips}"]
}
