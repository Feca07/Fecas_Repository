load("C:/Users/ikerf/Downloads/TERCERO/SegundoCuatri/M_Dades_Complexes/Ejemplo_1.rdata")
ejemplo_1
library(bnlearn)
library(Rgraphviz)
names= c("X1","X2")
net=empty.graph(names)
net
class(net)
arcs(net)=matrix(c("X1","X2"),ncol=2,byrow = T,dimnames = list(c(),c("from","to")))
net
plot1=graphviz.plot(net)

net.estimated=bn.fit(net,ejemplo_1,method="mle");net.estimated
class(net.estimated)
coefs=coefficients(net.estimated);coefs
