
### Terraform install
```
$ curl https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip -o /tmp/terraform.zip && sudo unzip /tmp/terraform.zip -d /usr/bin/
```

###Provisioners install
```
$ sudo curl -sL https://github.com/jonmorehouse/terraform-provisioner-ansible/releases/download/0.0.2/terraform-provisioner-ansible -o /usr/local/bin/terraform-provisioner-ansible
```

###Provisioners enable
```
$ vi ~/.terraformrc

providers {
    ansible = "/usr/local/bin/terraform-provisioner-ansible"
}

```