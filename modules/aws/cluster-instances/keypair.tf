
resource "aws_key_pair" "main" {
  key_name   = "KP-${var.environment}-default"
  #public_key = "file("${path.module}/file")"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCUY1etBt7eQUB5sysa8OkZNrEdEv+YfnixGSwUhGLFH5ozirTDdL0HnE18HmGHgvE1uEeZU6eAwvxyDAUL+WkXMTaxsp9drkOHdeCj8Gq69C9+q8OZUQqNuWi5ythRDGSFJ/pGOcMByDlQdAfoEHXjCfiMwKxhTyrGClmhbKL7FXDOuqE8iIMJVHo/Z7DOX2m6GvUnuUfhAXce/LAUsJlf44S7qXiLzdTnO3shZ2dDsVCKrhLEqnIMh/t+44P/DXuqdGsM54dHBC0W7UIMhQ9YLo9Khyy2Vyv5BuFsJvYwPxrOWDj+fkB79RMdroV9xmv2NQdIRk0qRBYw+fLTbr4h ansible-priv"
}

