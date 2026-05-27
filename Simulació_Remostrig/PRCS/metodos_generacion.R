rexp.custom=function(lambda){
  u=runif(n)
  finv=-log(u)/lambda
  
}

n=10000
hist(rexp.custom(5))

rweibull.costom= function(beta,alpha=1){
  u=runif(n)
  Finv=(-beta)*(log(-u+1))^(1/(alpha))
}

rweibull.costom(5)
hist(rweibull.costom(5))

rpoisson.custom=function(lambda){
  n=max(100000) 
  u=runif(n)
  x=-log(u)/lambda
  temps=cumsum(x)
  N=sum(temps <= 1)
}

data=replicate(1000,rpoisson.custom(5))
hist(data)
