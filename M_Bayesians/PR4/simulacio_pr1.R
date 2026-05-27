########################### Objectiu simular una Normal (0,1)

{# Densidad objetivo: Normal estándar
f <- function(x) {
  dnorm(x, mean = 0, sd = 1)
}

# Densidad propuesta: Cauchy estándar
g <- function(x) {
  dcauchy(x, location = 0, scale = 1)
}



ratio <- function(x) {
  f(x) / g(x)
}


#### visualmente
curve(ratio(x), from = -5, to = 5,
      ylab = "f(x)/g(x)",
      main = "Cociente Normal / Cauchy")
abline(v = c(-1, 1), col = "red", lty = 2)


# numericamente
res <- optimize(ratio, interval = c(-10, 10), maximum = TRUE)
res

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
  y <- rcauchy(1)
  
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
     main = "Aceptación–Rechazo: Normal estándar",
     xlab = "x")

curve(dnorm(x), col = "red", lwd = 2, add = TRUE)
}


########################### Simulacion posterior, aplicando AR


# Dato observado
x_obs <- 4

# Log-verosimilitud (sin constantes)
llike <- function(theta) {
  x_obs * log(theta) - theta
}


# Prior: Uniforme(0,10)
g <- function(theta) {
  dunif(theta, 0, 10)
}

ratio <- function(theta) {
  exp(llike(theta))
}

res <- optimize(ratio, interval = c(0.001, 10), maximum = TRUE)
res


c <- res$objective


curve(ratio(x), from = 0, to = 10,
      ylab = "L(x | theta)",
      main = "Verosimilitud Poisson (x = 4)")
abline(v = res$maximum, col = "red", lty = 2)




nsim <- 10000
theta <- numeric(nsim)

i <- 1
rechazos <- 0

while (i <= nsim) {
  
  # Paso 1: proponer desde la prior
  y <- runif(1, 0, 10)
  
  # Paso 2: uniforme
  u <- runif(1)
  
  # Paso 3: criterio AR (en escala log)
  if (log(u) <= llike(y) - log(c)) {
    theta[i] <- y
    i <- i + 1
  } else {
    rechazos <- rechazos + 1
  }
}





hist(theta, prob = TRUE, breaks = 40,
     xlim = c(0,15), ylim=c(0,1),
     main = "Posterior simulada",
     xlab = expression(theta))

curve(dgamma(x, shape = 5, rate = 1),
      from = 0, to = 15,
      col = "red", lwd = 2, add = TRUE)



rendiment_teoric <- 1 / c
rendiment_teoric