###Entregable de clase

### 1 Generar Cauchy(0,1)

rcauchy.custom= function(n){
  u=runif(n)
  finv = tan(pi * (u - 0.5))
  return(finv)
}

# Densidades (deterministas)
dnorm.custom <- function(x){
  (1 / sqrt(2*pi)) * exp(-x^2 / 2)
}

dcauchy.custom <- function(x){
  1 / (pi * (1 + x^2))
}

# Constante teórica óptima
c_teorica <- sqrt(2*pi) * exp(-1/2)


ratio_fg <- function(x) dnorm.custom(x) / dcauchy.custom(x)
opt <- optimize(ratio_fg, interval = c(0, 10), maximum = TRUE)
c_calc <- opt$objective
x_argmax <- opt$maximum

c_teorica
c_calc