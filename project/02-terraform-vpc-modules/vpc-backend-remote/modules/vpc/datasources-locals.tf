# data block
data "aws_availability_zones" "available" {
  # aqui estamos invocando la data que llegaremos usar para trabajar con otras funciones
  # en el futuro. O sea, simplemente estamos llamando una funcion que nos da la lista de azs.
  state = "available"
}


# local block
locals {
  # esto nos permite consultar la data y presentar los 3 primeros elementos usando el slice function.
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets  = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k)]
  private_subnets = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k + 10)]
}

# Función cidrsubnet: Esta función se utiliza para calcular las direcciones de subred dentro de un rango de direcciones
# de red IP especificado. Para esto, se requiere el rango de la red VPC, en este caso, 10.0.0.0/16, y
# la cantidad de bits para definir el tamaño de la subred, como /24 o /20. En este caso usamos /24 que son 8 bits y
# que se encuentra ya en nuestro VPC CIDR block.
