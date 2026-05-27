# Simulació. Pràctica 3 

## 11
dens.triangular <- function(x) {
  if ((0 <= x) && (x <= 1)) {
    return(x)
  }
  if ((1 <= x) && (x <= 2)) {
    return(2 - x)
  }
  if ((x < 0) && (x > 2)) {
    return(0)
  }
}

acceptacio <- function() {
  while (TRUE) {
    y <- 2 * runif(min = 0, max = 1, n = 1)
    u <- runif(min = 0, max = 1, n = 1)
    if (u < dens.triangular(y))
      return(y)
  }
}

mida <- 10000
mostra <- numeric(mida)
for (i in 1:mida) {
  mostra[i] <- acceptacio()
}

hist(
  mostra,
  breaks = seq(from = 0, to = 2, by = 0.1),
  freq = FALSE,
  ylim = c(0, 1.5)
)
points <- seq(from = 0, to = 2, by = 0.01)
lines(points, sapply(points, dens.triangular))



## 12
points <- seq(from = 0, to = 5, by = 0.01)
plot(points,
     dexp(rate = 1, x = points),
     type = "l",
     col = "blue")
lines(points, sqrt(2 / pi) * exp(-points ^ 2 / 2), col = "red")
# L'expressió simplificada que es demana és exp(-(1-x^2)/2).
# Per comptar la proporció d'acceptacions, podem comptar
# quantes generacions calen fem per obtenir una mostra completa:
generacions <- 0
acceptacio <- function() {
  while (TRUE) {
    generacions <<- generacions + 1
    y <- rexp(rate = 1, n = 1) #alternativa: -log(runif(min=0, max=1, n=1))
    u <- runif(min = 0, max = 1, n = 1)
    if (u < exp(-(1 - y) ^ 2 / 2))
      return(y)
  }
}

mida <-10000
mostra <- numeric(mida) 
for (i in 1:mida) {
  mostra[i] <- acceptacio()
}


S <- sample(c(-1, 1),
            prob = c(1 / 2, 1 / 2),
            replace = TRUE,
            size = mida)
  #alternativa: sign(2 * unif(min = 0, max = 1, n = mida) - 1)
mostra <- mostra * S

# Comprovació dibuixant histograma i densitat de Normal:
densitatNormal <- function(point){
dnorm(x=point, mean=0, sd=1)}

hist(mostra,
     breaks = seq(from=-10, to=10, by=0.5),
     freq = FALSE, ylim = c(0, 0.5)
)
points <- seq(from = -6, to = 6, by = 0.01)
lines(points, sapply(points, densitatNormal))

# Comptem proporció d'acceptacions (aproxima la constant C)
print(mida/generacions)

# 13
mbm <- microbenchmark(version1 = {
  generacions <- 0
  acceptacio <- function() {
    while (TRUE) {
      generacions <<- generacions + 1
      y <-
        rexp(rate = 1, n = 1) #alternativa: -log(runif(min=0, max=1, n=1))
      u <- runif(min = 0, max = 1, n = 1)
      if (u < exp(-(1 - y) ^ 2 / 2))
        return(y)
    }
  }
  
  mida <- 10000
  mostra <- numeric(mida)
  for (i in 1:mida) {
    mostra[i] <- acceptacio()
  }
  
  S <- sample(
    c(-1, 1),
    prob = c(1 / 2, 1 / 2),
    replace = TRUE,
    size = mida
  )
  #alternativa: sign(2 * unif(min = 0, max = 1, n = mida) - 1)
  mostra <- mostra * S
},

version2 = {
  generacions <- 0
  acceptacio <- function() {
    while (TRUE) {
      generacions <<- generacions + 1
      y <-
        rexp(rate = 1, n = 1) #alternativa: -log(runif(min=0, max=1, n=1))
      u <- runif(min = 0, max = 1, n = 1)
      bound <- exp(-(1 - y) ^ 2 / 2)
      if (u < bound / 2) {
        return(-y)
      }
      else if (u < bound) {
        return(y)
      }
    }
  }
  
  mida <- 10000
  mostra <- numeric(mida)
  for (i in 1:mida) {
    mostra[i] <- acceptacio()
  }
  
})

print(mbm)
#Surt pitjor la segona opció.Possiblement perquè és més costós
# fer una comparació que generar una altra uniforme.

## 14
normalGeneral <- function(mu, sigma) {
  generacions <- 0
  acceptacio <- function() {
    while (TRUE) {
      generacions <<- generacions + 1
      y <-
        rexp(rate = 1, n = 1) #alternativa: -log(runif(min=0, max=1, n=1))
      u <- runif(min = 0, max = 1, n = 1)
      if (u < exp(-(1 - y) ^ 2 / 2))
        return(y)
    }
  }
  
  mida <- 10000
  mostra <- numeric(mida)
  for (i in 1:mida) {
    mostra[i] <- acceptacio()
  }
  
  
  S <- sample(
    c(-1, 1),
    prob = c(1 / 2, 1 / 2),
    replace = TRUE,
    size = mida
  )
  #alternativa: sign(2 * unif(min = 0, max = 1, n = mida) - 1)
  mostra <- mostra * S
  mostra <- sigma * mostra + mu
  
  # Comprovació dibuixant histograma i densitat de Normal:
  densitatNormal <- function(point) {
    dnorm(x = point, mean = mu, sd = sigma)
  }
  
  hist(
    mostra,
    breaks = seq(from = -10, to = 10, by = 0.5),
    freq = FALSE,
    ylim = c(0, 0.5)
  )
  points <- seq(from = -6, to = 6, by = 0.01)
  lines(points, sapply(points, densitatNormal))
  
  # Comptem proporció d'acceptacions (aproxima la constant C)
  print(mida / generacions)
  
}

normalGeneral(1, 2)

##15 Falta completar
dens.lleiBeta <- function(x) {
  if( x<1 && x>0) 
    return(20*x*(1-x)^3)
  else 
    return(0)
}

x <- seq(from=0, to=1, by=0.01)
plot(x, sapply(x, dens.lleiBeta), type="l")

############################################################################################################################################
############################################################################################################################################
############################################################################################################################################
#En clas
############################################################################################################################################
############################################################################################################################################
############################################################################################################################################
set.seed(57)

rexp.custom= function(lambda){
  return (-log(runif(1))/lambda)
}

c= 1.28
rnorm.custom3= function(c){
  y=rexp.custom(1)
  u=runif(1)
  f=sqrt(2/pi)*exp((-y^2)/2)
  g=exp(-y)
  if(u<= (f/(c*g))){
    return(y)
  }
  else {return(NA)}
}
set.seed(57)
mednorm=replicate(1000,rnorm.custom3(c=c))
summary(mednorm)

B=1000
x=NULL
c= 1.28
#start.time=Sys.time()
#library(tictoc)
#tic()

for (i in 1:B){
  y=rexp.custom(1)
  u=runif(1)
  f=sqrt(2/pi)*exp((-y^2)/2)
  g=exp(-y)
  if(u<= (f/(c*g))){
    x[i]=y
  }
  else x[i]=NA
}
microbenchmark()
#toc()
#end.time=Sys.time()
#end.time-start.time
x
hist(x)

library(microbenchmark)
test=microbenchmark(for (i in 1:B){
  y=rexp.custom(1)
  u=runif(1)
  f=sqrt(2/pi)*exp((-y^2)/2)
  g=exp(-y)
  if(u<= (f/(c*g))){
    x[i]=y
  }
  else x[i]=NA
})
print(test)
summary(test,unit = "seconds")

time2=microbenchmark(replicate(1000,rnorm.custom3(c=c)))
summary(time2,unit = "seconds")

dab=c(-1,1)
mednorm=replicate(1000,rnorm.custom3(c=c))
norm=replicate(1000,dab*rnorm.custom3(c=c))
hist(norm,breaks = 10)
hist(dab*mednorm)



ano=dab*mednorm
y=5+sqrt(2)*norm
hist(y)
shapiro.test(ano)
