# Posterior no normalizada
posterior <- function(lambda){
  if(lambda <= 0) return(0)
  # likelihood
  lik <- prod(dpois(x, lambda))
  # prior Weibull
  prior <- dweibull(lambda, shape = 3.6, scale = 2)
  # posterior no normalizada
  lik * prior
}
posterior <- function(lambda){
  if(lambda <= 0) return(0)
  # likelihood simplificada
  likelihood <- exp(-25 * lambda) * lambda^70
  # prior Weibull
  prior <- dweibull(lambda, shape = 3.6, scale = 2)
  # posterior no normalizada
  likelihood * prior
}

set.seed(123)
N <- 5000
lambda <- numeric(N)
lambda[1] <- 2.8 # punt inicial
sigma <- 1
for(i in 2:N){
  candidate <- lambda[i-1] + rnorm(1, 0, sigma)
  alpha <- min(1, posterior(candidate) / posterior(lambda[i-1]))
  if(runif(1) < alpha){
    lambda[i] <- candidate
  } else {
    lambda[i] <- lambda[i-1]
  }
}

ts.plot(lambda, ylab="lambda", main="Traceplot de la cadena MCMC")
acf(lambda, main="Funció d'autocorrelación")

burnin <- 1000
lambda_burn <- lambda[(burnin+1):N]
lambda_thin <- lambda_burn[seq(1, length(lambda_burn), by = 10)]
acf(lambda_thin, main="Función de autocorrelación")

hist(lambda_thin, probability = TRUE, breaks = 30,
     main = "Posterior aproximada de lambda",
     xlab = "lambda")
mean(lambda_thin)
sd(lambda_thin)
quantile(lambda_thin, c(0.025, 0.5, 0.975))

library(MCMCpack)

post <- MCMCmetrop1R(
  fun = posterior,
  theta.init = 2.8,
  mcmc = 50000,
  burnin = 1000,
  thin = 10,
  V = matrix(1),
  logfun = FALSE
)

summary(post)

plot(post)
acf(post)

############################################################################################################################################
############################################################################################################################################
############################################################################################################################################

x <- c(3,4,2,5,3,4,3,2,6,3,4,3,5,2,3,4,3,5,4,3,2,3,4,5,3,4,2,3,4,5)

posterior <- function(lambda){
  if(lambda <= 0) return(0)
  # likelihood simplificada
  likelihood <- exp(-30 * lambda) * lambda^106
  # prior Weibull
  prior <- dweibull(lambda, shape = 3.6, scale = 2)
  # posterior no normalizada
  likelihood * prior
}

set.seed(123)
lambda <- x
sigma <- 1
for(i in 2:N){
  candidate <- lambda[i-1] + rnorm(1, 0, sigma)
  alpha <- min(1, posterior(candidate) / posterior(lambda[i-1]))
  if(runif(1) < alpha){
    lambda[i] <- candidate
  } else {
    lambda[i] <- lambda[i-1]
  }
}

ts.plot(lambda, ylab="lambda", main="Traceplot de la cadena MCMC")
acf(lambda, main="Funció d'autocorrelación")

burnin <- 1000
lambda_burn <- lambda[(burnin+1):N]
lambda_thin <- lambda_burn[seq(1, length(lambda_burn), by = 10)]
acf(lambda_thin, main="Función de autocorrelación")

hist(lambda_thin, probability = TRUE, breaks = 30,
     main = "Posterior aproximada de lambda",
     xlab = "lambda")
mean(lambda_thin)
sd(lambda_thin)
quantile(lambda_thin, c(0.025, 0.5, 0.975))

notas_dab=c(10,9)