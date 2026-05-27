
##### EXERCICI CLASE

# Simula un Gamma(2,1) a través de la Exp(1)
# Argumenta perque no es possible i fes-ho amb un EXP(0.5)

#### Objectiu simular una Gamma (2,1)

{# Densidad objetivo: gamma
  f <- function(x) {
    dgamma(x,shape= 2, rate = 1)
  }
  
  # Densidad propuesta: exponencial
  g <- function(x) {
    dexp(x, 1)
  }
  
  
  
  ratio <- function(x) {
    f(x) / g(x)
  }
  
  
  #### visualmente
  
  curve(ratio(x), from = 0, to = 10,
        ylab = "f(x)/g(x)",
        main = "Cociente Gamma(2,1) / Exponencial(1)")
  abline(v = 1, col = "red", lty = 2)
  
  
  
  # numericamente
  
  res <- optimize(ratio, interval = c(0, 10), maximum = TRUE)
  res
  
  
}



#### Objectiu simular una Gamma (2,1)

{# Densidad objetivo: gamma
  f <- function(x) {
    dgamma(x,shape= 2, rate = 1)
  }
  
  # Densidad propuesta: exponencial
  g <- function(x) {
    dexp(x, 0.5)
  }
  
  
  
  ratio <- function(x) {
    f(x) / g(x)
  }
  
  
  
  # numericamente
  
  res <- optimize(ratio, interval = c(0, 10), maximum = TRUE)
  res
  
  
  
  #### visualmente
  
  curve(ratio(x), from = 0, to = 10,
        ylab = "f(x)/g(x)",
        main = "Cociente Gamma(2,1) / Exponencial(0.5)")
  abline(v = res$maximum, col = "red", lty = 2)
  
  
  # Constante c
  c <- res$objective
  
  
  
  # Número de simulaciones que queremos
  nsim <- 10000
  
  # Vector para guardar los valores aceptados
  x <- numeric(nsim)
  
  i <- 1
  rechazos <- 0
  
  while (i <= nsim) {
    
    # Paso 1: generar candidato desde g
    y <- rexp(1,0.5)
    
    # Paso 2: generar uniforme
    u <- runif(1)
    
    # Paso 3: criterio de aceptación
    if (u <= f(y) / (c * g(y))) {
      x[i] <- y
      i <- i + 1
    } else {
      rechazos <- rechazos + 1
    }
  }
  
  
  hist(x, prob = TRUE, breaks = 40,
       main = "Aceptación–Rechazo: Gamma(2,1)",
       xlab = "x")
  
  curve(dexp(x), col = "red", lwd = 2, add = TRUE)
  
  
  #Rendiment 
  
  1/c*100  #teoric
  
  #empiric
  rendiment <- nsim / (nsim + rechazos)
  rendiment
  
  
}




#### EJEMPLO 2, lo van a resolver ellos

############################################################
# SIMULACIÓN DE LA POSTERIOR CON ACEPTACIÓN–RECHAZO
# Modelo: Xi ~ Normal(mu, sigma)
# Priors: mu ~ Uniform(8,32), sigma ~ Uniform(1,10)
############################################################
############################################################
# SIMULACIÓN DE LA POSTERIOR CON ACEPTACIÓN–RECHAZO
############################################################

# Datos
x <- c(17,13,18,19,17,21,29,22,16,28,
       21,15,26,23,24,20,8,17,17,21,
       32,18,25,22,16,10,20,22,19,14,
       30,22,12,24,28,11)

n <- length(x)



# Priors (propuesta)
rprior_mu <- function() runif(1, 8, 32)
rprior_sigma <- function() runif(1, 1, 10)

# MLE clásicos (punto inicial)
mu_mle <- mean(x)
sigma_mle <- sd(x) * sqrt((n - 1) / n)

############################################################
# Cálculo de log(c): máximo del log-likelihood
############################################################
############################################################
# Log-verosimilitud
############################################################

# Trabajamos con la log‑verosimilitud en lugar de la verosimilitud
# porque:
# 1) El likelihood es un PRODUCTO de muchas densidades, que da números
#    extremadamente pequeños (problemas numéricos).
# 2) El log‑likelihood convierte el producto en una SUMA, mucho más estable.
# 3) Maximizar el likelihood es equivalente a maximizar el log‑likelihood,
#    porque el logaritmo es una función estrictamente creciente.

llike <- function(mu, sigma) {
  sum(dnorm(x, mean = mu, sd = sigma, log = TRUE))
}

############################################################
# Estimaciones MLE (solo como punto inicial)
############################################################

# Estas estimaciones se usan únicamente como punto de partida
# para el método numérico de optimización.

mu_mle <- mean(x)
sigma_mle <- sd(x) * sqrt((n - 1) / n)

############################################################
# Función a MINIMIZAR
############################################################

# La función optim() SIEMPRE MINIMIZA.
# Como queremos MAXIMIZAR el log‑likelihood,
# definimos su opuesto (−log‑likelihood).

neg_llike <- function(par) {
  
  mu <- par[1]
  sigma <- par[2]
  
  # Este if garantiza que la búsqueda se haga
  # SOLO dentro del soporte de la prior:
  # mu ∈ [8,32], sigma ∈ [1,10].
  # Valores fuera del soporte se penalizan con Inf
  # para que nunca sean óptimos.
  
  if (mu < 8 || mu > 32 || sigma < 1 || sigma > 10) {
    return(Inf)
  }
  
  # Devolvemos el negativo del log‑likelihood
  # para que minimizar esta función sea equivalente
  # a maximizar la log‑verosimilitud.
  
  -llike(mu, sigma)
}

############################################################
# Optimización numérica
############################################################

# Aquí buscamos el MÁXIMO del log‑likelihood
# RESTRINGIDO al soporte de la prior.
# Usamos L‑BFGS‑B porque permite imponer cotas.

res <- optim(
  par = c(mu_mle, sigma_mle),   # punto inicial
  fn = neg_llike,               # función a minimizar
  method = "L-BFGS-B",
  lower = c(8, 1),
  upper = c(32, 10)
)

############################################################
# Constante c del método Aceptación‑Rechazo
############################################################

# res$value es el MÍNIMO de neg_llike,
# es decir:
#   res$value = − max log L(x | mu, sigma)
#
# Por tanto, si cambiamos el signo obtenemos:
#   llmax = max log L(x | mu, sigma)
#
# Este valor es exactamente log(c), donde
# c es la constante del método de aceptación–rechazo.

llmax <- -res$value   # log(c)
llmax

############################################################
# Aceptación–Rechazo
############################################################

nsim <- 1000
mu_post <- numeric(nsim)
sigma_post <- numeric(nsim)

co <- 0
tot <- 0

while (co < nsim) {
  
  mu <- rprior_mu()
  sigma <- rprior_sigma()
  
  u <- runif(1)
  
  if (log(u) <= llike(mu, sigma) - llmax) {
    co <- co + 1
    mu_post[co] <- mu
    sigma_post[co] <- sigma
  }
  
  tot <- tot + 1
}

# Rendimiento
eficiencia <- nsim / tot
eficiencia



hist(mu_post, prob = TRUE, breaks = 30,
     main = expression("Posterior de " ~ mu),
     xlab = expression(mu))

lines(density(mu_post), col = "red", lwd = 2)

mean(mu_post)
median(mu_post)
quantile(mu_post, c(0.025, 0.975))
