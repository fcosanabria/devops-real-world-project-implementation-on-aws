# Aqui estamos colocando un bloque random_string para generar un nombre aleatorio para el bucket.
# Esto por que AWS requiere nombres completamente unicos.
# Y le estamos llamando suffix, simplemente para referenciarlo en el bloque de la variable.

resource "random_string" "suffix" {
  length = 6
  special = false
  upper = false
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "devopsdemo-${random_string.suffix.result}"

  tags = {
    Name        = "DevOps Demo Bucket"
    Environment = "Dev"
  }
}