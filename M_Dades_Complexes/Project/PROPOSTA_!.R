#################################################################
#0. Càrrega de dades
#################################################################
library(readr)
vino <- read_delim("winequality-white.csv", 
                   delim = ";", escape_double = FALSE, trim_ws = TRUE)

table(vino$quality)
cor(vino)
#Separem en Baixa (3,4,5), Mitjana (6) i Alta (7,8,9)
vino$quality <- cut(vino$quality, breaks=c(0,6,7,10), right=F, labels = c("Baixa", "Mitjana", "Alta"))
table(vino$quality)

#################################################################
#1. Preprocessament
#################################################################

par(mfrow=c(3,4))
sapply(names(vino[1:11]), function(var) {hist(vino[[var]],breaks=10, main = var, xlab = var, col = "lightpink")})
par(mfrow=c(1,1))

library(bnlearn)
library(gRain)

predictores <- vino[, names(vino) != "quality"]
predictores_disc <-discretize(predictores, method = "hartemink", 
                              breaks = 6, ibreaks = 60, idisc = "quantile")
data <- cbind(predictores_disc, quality = vino$quality)

#Passem a factor totes les variables
data <- as.data.frame(lapply(data, as.factor))
summary(data)

#Gràfic de barres per a observar l'equilibri de la discretització
par(mfrow=c(3,4))
sapply(names(data[1:11]), function(var) {
  barplot(table(data[[var]]), main = var, xlab = var, col = "lightpink", las=2)
})
par(mfrow=c(1,1))

#################################################################
#2. Models 
#################################################################

#Comencem amb el Nive Bayes

nb_structure <- naive.bayes(data, "quality") #Definim estructura (Naive)
graphviz.plot(nb_structure, main = "Estructura Naive Bayes") #Visualitzem l'esteuctura
nb_fit <- bn.fit(nb_structure, data,method = "bayes", iss = 1) #Ajustem el model
nb_grain <- as.grain(nb_fit) #Convertim a format Grain
nb_grain <- compile(nb_grain) #Compilem

#Aquesta es la base, ara ho fem amb K-fold cross-validation

set.seed(57)
k <- 10
n <- nrow(data)

indices <- sample(1:n)
folds <- cut(seq_along(indices), breaks = k, labels = FALSE)

pred_nb <- character(n)

for (i in 1:k) {
  
  test_idx  <- indices[which(folds == i)]
  train_data <- data[-test_idx, ]
  test_data  <- data[test_idx, ]
  
  nb_struct <- naive.bayes(train_data, "quality")
  
  nb_fit <- bn.fit(nb_struct, data = train_data, method = "bayes", iss = 1)
  
  nb_grain <- as.grain(nb_fit)
  nb_grain <- compile(nb_grain)
  
  pred_fold <- sapply(1:nrow(test_data), function(j) {
    
    evidencia <- as.list(test_data[j, names(test_data) != "quality"])
    
    xarxa_ev <- setEvidence(nb_grain, 
                            nodes = names(evidencia), 
                            states = as.character(unlist(evidencia)))
    
    prob_quality <- querygrain(xarxa_ev, nodes = "quality")$quality
    
    names(which.max(prob_quality))
  })
  
  pred_nb[test_idx] <- pred_fold
}

#Mètriques

#################################################################################################
#################################################################################################
#################################################################################################

metriques_clasificacio <- function(real, pred) {
  
  clases <- union(levels(factor(real)), levels(factor(pred)))
  real <- factor(real, levels = clases)
  pred <- factor(pred, levels = clases)
  
  cm <- table(Real = real, Prediccion = pred)
  
  n <- sum(cm)
  tp <- diag(cm)
  fp <- colSums(cm) - tp
  fn <- rowSums(cm) - tp
  tn <- n - tp - fp - fn
  
  safe_div <- function(num, den) {
    ifelse(den == 0, NA, num / den)
  }
  
  precissio <- safe_div(tp, tp + fp)
  sensibilitat <- safe_div(tp, tp + fn)
  f1 <- safe_div(2 * precissio * sensibilitat, precissio + sensibilitat)
  
  metriques_class <- data.frame(
    Clase = clases,
    precissio = precissio,
    sensibilitat = sensibilitat,
    F1_score = f1,
    Soporte = rowSums(cm)
  )
  
  accuracy <- sum(tp) / n
  
  precissio_tot <- mean(precissio, na.rm = TRUE)
  sensibilitat_tot <- mean(sensibilitat, na.rm = TRUE)
  f1_macro <- mean(f1, na.rm = TRUE)
  
  c_val <- sum(tp)
  s <- n
  p_k <- colSums(cm)
  t_k <- rowSums(cm)
  
  numerador <- c_val * s - sum(p_k * t_k)
  denominador <- sqrt((s^2 - sum(p_k^2)) * (s^2 - sum(t_k^2)))
  
  mcc <- ifelse(denominador == 0, NA, numerador / denominador)
  
  return(list(
    matriz_confusion = cm,
    accuracy = accuracy,
    precissio_tot = precissio_tot,
    sensibilitat_tot = sensibilitat_tot,
    f1_macro = f1_macro,
    mcc = mcc,
    metriques_class = metriques_class
  ))
}

#################################################################################################
#################################################################################################
#################################################################################################

#Observem els resultats: 

resultats_nb <- metriques_clasificacio(data$quality, pred_nb)

cat("Accuracy:", round(resultats_nb$accuracy, 4), "\n")
cat("precissio de tot:", round(resultats_nb$precissio_tot, 4), "\n")
cat("sensibilitat de tot:", round(resultats_nb$sensibilitat_tot, 4), "\n")
cat("F1 de tot:", round(resultats_nb$f1_macro, 4), "\n")
cat("MCC:", round(resultats_nb$mcc, 4), "\n")
print(resultats_nb$metriques_class)

#Continuem amb l'Augmented Naive Bayes (TAN)

tan_structure <- tree.bayes(data, "quality") #Definim estructura (TAN)
graphviz.plot(tan_structure, main = "Estructura Augmented Naive Bayes (TAN)") #Visualitzem l'estructura
tan_fit <- bn.fit(tan_structure, data, method = "bayes", iss = 1) #Ajustem el model
tan_grain <- as.grain(tan_fit) #Convertim a format gRain
tan_grain <- compile(tan_grain) #Compilem

#Aquesta es la base, ara ho fem amb K-fold cross-validation

set.seed(57)
pred_tan <- character(n)

for (i in 1:k) {
  
  test_idx   <- indices[which(folds == i)]
  train_data <- data[-test_idx, ]
  test_data  <- data[test_idx, ]
  
  tan_struct <- tree.bayes(train_data, "quality")
  
  tan_fit <- bn.fit(tan_struct, data = train_data, method = "bayes", iss = 1)
  
  tan_grain <- as.grain(tan_fit)
  tan_grain <- compile(tan_grain)
  
  pred_fold <- sapply(1:nrow(test_data), function(j) {
    
    evidencia <- as.list(test_data[j, names(test_data) != "quality"])
    
    xarxa_ev <- setEvidence(tan_grain,
                            nodes  = names(evidencia),
                            states = as.character(unlist(evidencia)))
    
    prob_quality <- querygrain(xarxa_ev, nodes = "quality")$quality
    
    names(which.max(prob_quality))
  })
  
  pred_tan[test_idx] <- pred_fold
}

# Mètriques

resultats_tan <- metriques_clasificacio(data$quality, pred_tan)

cat("Accuracy:", round(resultats_tan$accuracy, 4), "\n")
cat("precissio de tot:", round(resultats_tan$precissio_tot, 4), "\n")
cat("sensibilitat de tot:", round(resultats_tan$sensibilitat_tot, 4), "\n")
cat("F1 de tot:", round(resultats_tan$f1_macro, 4), "\n")
cat("MCC:", round(resultats_tan$mcc, 4), "\n")
print(resultats_tan$metriques_class)
