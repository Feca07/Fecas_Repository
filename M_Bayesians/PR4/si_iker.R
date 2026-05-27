### Exercici 1


  f <- function(x) {
    dgamma(x, shape = 2, rate=1)
  }
  
  # Densidad propuesta: Cauchy estándar
  g <- function(x) {
    dexp(x, rate=0.5)
  }
  
  
  
  ratio <- function(x) {
    f(x) / g(x)
  }
  
  
  #### visualmente
  curve(ratio(x), from = 0, to = 10,
        ylab = "f(x)/g(x)",
        main = "Cociente Normal / Cauchy")

  
  # numericamente
  res <- optimize(ratio, interval = c(0, 10), maximum = TRUE)
  res
  
  # Constante c
  c <- res$objective
  
  
  
  # Número de simulaciones que queremos
  nsim <- 100000
  
  # Vector para guardar los valores aceptados
  x <- numeric(nsim)
  
  i <- 1
  rechazos <- 0
  
  while (i <= nsim) {
    
    # Paso 1: generar candidato desde g
    y <- rexp(1,rate=0.5)
    
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
  
  
  hist(x, prob = TRUE, breaks = 100,col = "pink",
       main = "Aceptación–Rechazo: Normal estándar",
       xlab = "x")
  
  curve(dgamma(x,shape=2,rate=1), col = "red", lwd = 2, add = TRUE)
}

  nsim/(nsim+rechazos)
#teoric
  1/c
  
  
  
  
  ### daaabb 2
  
  x <- c(17,13,18,19,17,21,29,22,16,28,
         21,15,26,23,24,20,8,17,17,21,
         32,18,25,22,16,10,20,22,19,14,
         30,22,12,24,28,11)
  n <- length(x)
  mean(x)
  sd(x)
  
  # Log-versemblança
  llike <- function(mu, sigma) {
    sum(dnorm(x, mean = mu, sd = sigma, log = TRUE))
  }
  mu_mle <- mean(x)
  sigma_mle <- sd(x) * sqrt((n - 1) / n)
  neg_llike <- function(par) {
    mu <- par[1]
    sigma <- par[2]
    if (mu < 8 || mu > 32 || sigma < 1 || sigma > 10) {
      return(Inf)
    }
    -llike(mu, sigma)
  }
  res <- optim(
    par = c(mu_mle, sigma_mle),
    fn = neg_llike,
    method = "L-BFGS-B",
    lower = c(8, 1),
    upper = c(32, 10)
  )
  llmax <- -res$value # log(c)
  llmax

    