x <- c(17,13,18,19,17,21,29,22,16,28,21,15,26,23,24,20,8,17,
       17,21,32,18,25,22,16,10,20,22,19,14,30,22,12,24,28,11)
n <- length(x)
iters <- 11000
mu <- numeric(iters)
s2 <- numeric(iters)
mu[1] <- mean(x)
s2[1] <- var(x)
library(invgamma)
for(i in 2:iters){
  # 1. Simulem mu condicionat a sigmaˆ2 anterior
  mu[i] <- rnorm(1, mean(x), sqrt(s2[i-1]/n))
  # 2. Simulem sigmaˆ2 condicionat al nou mu
  s2[i] <- rinvgamma(1,
                     shape = (n)/2,
                     rate = n*(var(x)+(mean(x)-mu[i])^2)/2)
}

par(mfrow=c(2,2))
plot(mu, type='l', main='Traceplot mu')
plot(s2, type='l', main='Traceplot sigma2')
hist(mu, prob=TRUE, main='Posterior mu')
hist(s2, prob=TRUE, main='Posterior sigma2')

summary(mu)
quantile(mu, c(0.025, 0.975))
summary(s2)
quantile(s2, c(0.025, 0.975))
par(mfrow=c(1,1))

acf(mu)
acf(s2)

library(MCMCpack)

temp <- seq(0, 100, length.out=50)
yield <- 5 - 0.1*temp + 0.001*temp^2 + rnorm(50,0,0.3)
library(tictoc)
tic()
fit <- MCMCregress(yield ~ temp + I(temp^2),
                   burnin = 1000,
                   mcmc = 20000,
                   thin = 2)
toc()

summary(fit)

acf(fit)
acf(fit)