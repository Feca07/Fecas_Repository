# 1708253  - 1703430 - 1704341

#################################################################
#0. Càrrega de dades
#################################################################
library(readr)
vino <- read_delim("winequality-white.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)
table(vino$quality)
View(vino)
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

predictors <- vino[, names(vino) != "quality"]
predictors_disc <- discretize(predictors, method = "hartemink", breaks = 6, ibreaks = 60, idisc = "quantile")

data <- cbind(predictors_disc, quality = vino$quality)

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

source("metriques.R")

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
indexs <- sample(1:n)
folds <- cut(seq_along(indexs), breaks = k, labels = FALSE)
pred_nb <- character(n)
acc_nbs <- NULL
mcc_nbs  <- NULL
f1_nbs   <- NULL
mae_nbs  <- NULL

for (i in 1:k) {
  
  test_idx  <- indexs[which(folds == i)]
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
  
  reals_fold <- data$quality[test_idx]
  acc_nbs[i] <- mean(pred_fold==as.character(reals_fold))
  res_fold <- metriques_clasificacio(factor(reals_fold), pred_fold)
  mcc_nbs[i] <- res_fold$mcc
  f1_nbs[i]  <- res_fold$f1_macro
  mae_nbs[i] <- res_fold$mae
}

#Observem els resultats: 

resultats_nb <- metriques_clasificacio(data$quality, pred_nb)

cat("Accuracy:", round(resultats_nb$accuracy, 4), "\n")
cat("precissio de tot:", round(resultats_nb$precissio_tot, 4), "\n")
cat("sensibilitat de tot:", round(resultats_nb$sensibilitat_tot, 4), "\n")
cat("F1 de tot:", round(resultats_nb$f1_macro, 4), "\n")
cat("MCC:", round(resultats_nb$mcc, 4), "\n")
cat("MAE:", round(resultats_nb$mae, 4), "\n")
Resum_results=resultats_nb$metriques_class
colnames(Resum_results)=c("Classe","Precissio","Sensibilitat","F1","N")
print(Resum_results)

#Continuem amb l'Augmented Naive Bayes (TAN)

tan_structure <- tree.bayes(data, "quality") #Definim estructura (TAN)
graphviz.plot(tan_structure, main = "Estructura Augmented Naive Bayes (TAN)") #Visualitzem l'estructura
tan_fit <- bn.fit(tan_structure, data, method = "bayes", iss = 1) #Ajustem el model
tan_grain <- as.grain(tan_fit) #Convertim a format gRain
tan_grain <- compile(tan_grain) #Compilem

#Aquesta es la base, ara ho fem amb K-fold cross-validation

set.seed(57)
k <- 10
n <- nrow(data)
indexs <- sample(1:n)
folds <- cut(seq_along(indexs), breaks = k, labels = FALSE)
pred_tan <- character(n)
acc_tans <- NULL
mcc_tans  <- NULL
f1_tans   <- NULL
mae_tans  <- NULL

for (i in 1:k) {
  
  test_idx <- indexs[which(folds == i)]
  train_data <- data[-test_idx, ]
  test_data  <- data[test_idx, ]
  
  tan_struct <- tree.bayes(train_data, "quality")
  
  tan_fit <- bn.fit(tan_struct, data = train_data, method = "bayes", iss = 1)
  
  tan_grain <- as.grain(tan_fit)
  tan_grain <- compile(tan_grain)
  
  pred_fold <- sapply(1:nrow(test_data), function(j) {
    
    evidencia <- as.list(test_data[j, names(test_data) != "quality"])
    xarxa_ev <- setEvidence(tan_grain,nodes  = names(evidencia),states = as.character(unlist(evidencia)))
    prob_quality <- querygrain(xarxa_ev, nodes = "quality")$quality
    
    names(which.max(prob_quality))
  })
  
  pred_tan[test_idx] <- pred_fold
  
  reals_fold <- data$quality[test_idx]
  acc_tans[i] <- mean(pred_fold==as.character(reals_fold))
  res_fold    <- metriques_clasificacio(factor(reals_fold), pred_fold)
  mcc_tans[i] <- res_fold$mcc
  f1_tans[i]  <- res_fold$f1_macro
  mae_tans[i] <- res_fold$mae
}

#Mètriques

resultats_tan <- metriques_clasificacio(data$quality, pred_tan)

cat("Accuracy:", round(resultats_tan$accuracy, 4), "\n")
cat("precissio de tot:", round(resultats_tan$precissio_tot, 4), "\n")
cat("sensibilitat de tot:", round(resultats_tan$sensibilitat_tot, 4), "\n")
cat("F1 de tot:", round(resultats_tan$f1_macro, 4), "\n")
cat("MCC:", round(resultats_tan$mcc, 4), "\n")
cat("MAE:", round(resultats_tan$mae, 4), "\n")
Resum_results2=resultats_tan$metriques_class
print(Resum_results2)


####################################################################################################################################
####################################################################################################################################
####################################################################################################################################

predictors_disc <- discretize(predictors, method = "hartemink", breaks = 17, ibreaks = 170, idisc = "quantile")
data <- cbind(predictors_disc, quality = vino$quality)
data <- as.data.frame(lapply(data, as.factor))

#Naive Bayes

set.seed(57)
k <- 10
n <- nrow(data)
indexs <- sample(1:n)
folds <- cut(seq_along(indexs), breaks = k, labels = FALSE)
pred_nb2 <- character(n)
acc_nb2s <- NULL
mcc_nb2s  <- NULL
f1_nb2s   <- NULL
mae_nb2s  <- NULL

for (i in 1:k) {
  
  test_idx  <- indexs[which(folds == i)]
  train_data <- data[-test_idx, ]
  test_data  <- data[test_idx, ]
  
  nb2_struct <- naive.bayes(train_data, "quality")
  
  nb2_fit <- bn.fit(nb2_struct, data = train_data, method = "bayes", iss = 1)
  
  nb2_grain <- as.grain(nb2_fit)
  nb2_grain <- compile(nb2_grain)
  
  pred_fold <- sapply(1:nrow(test_data), function(j) {
    
    evidencia <- as.list(test_data[j, names(test_data) != "quality"])
    
    xarxa_ev <- setEvidence(nb2_grain, 
                            nodes = names(evidencia), 
                            states = as.character(unlist(evidencia)))
    
    prob_quality <- querygrain(xarxa_ev, nodes = "quality")$quality
    
    names(which.max(prob_quality))
  })
  
  pred_nb2[test_idx] <- pred_fold
  
  reals_fold <- data$quality[test_idx]
  acc_nb2s[i] <- mean(pred_fold==as.character(reals_fold))
  res_fold    <- metriques_clasificacio(factor(reals_fold), pred_fold)
  mcc_nb2s[i] <- res_fold$mcc
  f1_nb2s[i]  <- res_fold$f1_macro
  mae_nb2s[i] <- res_fold$mae
}

resultats_nb2 <- metriques_clasificacio(data$quality, pred_nb2)

cat("Accuracy:", round(resultats_nb2$accuracy, 4), "\n")
cat("precissio de tot:", round(resultats_nb2$precissio_tot, 4), "\n")
cat("sensibilitat de tot:", round(resultats_nb2$sensibilitat_tot, 4), "\n")
cat("F1 de tot:", round(resultats_nb2$f1_macro, 4), "\n")
cat("MCC:", round(resultats_nb2$mcc, 4), "\n")
cat("MAE:", round(resultats_nb2$mae, 4), "\n")
Resum_results3=resultats_nb2$metriques_class
print(Resum_results3)

#Tree Augmented Naive Bayes

set.seed(57)
k <- 10
n <- nrow(data)
indexs <- sample(1:n)
folds <- cut(seq_along(indexs), breaks = k, labels = FALSE)
pred_tan2 <- character(n)
acc_tan2s <- NULL
mcc_tan2s <- NULL
f1_tan2s <- NULL
mae_tan2s  <- NULL

for (i in 1:k) {
  
  test_idx <- indexs[which(folds == i)]
  train_data <- data[-test_idx, ]
  test_data  <- data[test_idx, ]
  
  tan2_struct <- tree.bayes(train_data, "quality")
  
  tan2_fit <- bn.fit(tan2_struct, data = train_data, method = "bayes", iss = 1)
  
  tan2_grain <- as.grain(tan2_fit)
  tan2_grain <- compile(tan2_grain)
  
  pred_fold <- sapply(1:nrow(test_data), function(j) {
    
    evidencia <- as.list(test_data[j, names(test_data) != "quality"])
    xarxa_ev <- setEvidence(tan2_grain,nodes  = names(evidencia),states = as.character(unlist(evidencia)))
    prob_quality <- querygrain(xarxa_ev, nodes = "quality")$quality
    
    names(which.max(prob_quality))
  })
  
  pred_tan2[test_idx] <- pred_fold
  
  reals_fold <- data$quality[test_idx]
  acc_tan2s[i] <- mean(pred_fold==as.character(reals_fold))
  res_fold    <- metriques_clasificacio(factor(reals_fold), pred_fold)
  mcc_tan2s[i] <- res_fold$mcc
  f1_tan2s[i]  <- res_fold$f1_macro
  mae_tan2s[i] <- res_fold$mae
}

#Mètriques

resultats_tan2 <- metriques_clasificacio(data$quality, pred_tan2)

cat("Accuracy:", round(resultats_tan2$accuracy, 4), "\n")
cat("precissio de tot:", round(resultats_tan2$precissio_tot, 4), "\n")
cat("sensibilitat de tot:", round(resultats_tan2$sensibilitat_tot, 4), "\n")
cat("F1 de tot:", round(resultats_tan2$f1_macro, 4), "\n")
cat("MCC:", round(resultats_tan2$mcc, 4), "\n")
cat("MAE:", round(resultats_tan2$mae, 4), "\n")
Resum_results4=resultats_tan2$metriques_class
print(Resum_results4)

##################################################################################################################################
##################################################################################################################################
##################################################################################################################################

#Tests de comparacions

# 6 breaks nb vs 17 breaks nb

##ACC
diferencies_nbs <- acc_nb2s-acc_nbs
shapiro_test <- shapiro.test(diferencies_nbs)
cat("p-valor Shapiro-Wilk:", shapiro_test$p.value, "\n")
test_result <- t.test(acc_nb2s, acc_nbs, paired = TRUE, alternative = "greater")
cat("p-valor test comparació (Paramètric):", test_result$p.value, "\n") ###guanya 17 breaks

##F1
diferenciesF_nbs <- f1_nb2s-f1_nbs
shapiro_test <- shapiro.test(diferenciesF_nbs)
cat("p-valor Shapiro-Wilk:", shapiro_test$p.value, "\n")
test_result <- t.test(f1_nb2s, f1_nbs, paired = TRUE, alternative = "greater")
cat("p-valor test comparació (Paramètric):", test_result$p.value, "\n") ###guanya 17 breaks

##MCC
diferenciesM_nbs <- mcc_nb2s-mcc_nbs
shapiro_test <- shapiro.test(diferenciesM_nbs)
cat("p-valor Shapiro-Wilk:", shapiro_test$p.value, "\n")
test_result <- t.test(mcc_nb2s, mcc_nbs, paired = TRUE, alternative = "greater")
cat("p-valor test comparació (Paramètric):", test_result$p.value, "\n") ###guanya 17 breaks

##MAE
diferenciesMa_nbs <- mae_nb2s-mae_nbs
shapiro_test <- shapiro.test(diferenciesMa_nbs)
cat("p-valor Shapiro-Wilk:", shapiro_test$p.value, "\n")
test_result <- t.test(mae_nb2s, mae_nbs, paired = TRUE, alternative = "less")
cat("p-valor test comparació (No Paramètric):", test_result$p.value, "\n") ###guanya 17 breaks

# 6 breaks tan vs 17 breaks tan

##ACC
diferencies_tans <- acc_tan2s-acc_tans
shapiro_test1 <- shapiro.test(diferencies_tans)
cat("p-valor Shapiro-Wilk:", shapiro_test1$p.value, "\n")
test_result <- t.test(acc_tan2s, acc_tans, paired = TRUE, alternative = "greater")
cat("p-valor test comparació (Paramètric):", test_result$p.value, "\n") ###guanya 17 breaks

##F1
diferenciesF_tans <- f1_tan2s-f1_tans
shapiro_test1 <- shapiro.test(diferenciesF_tans)
cat("p-valor Shapiro-Wilk:", shapiro_test1$p.value, "\n")
test_result <- t.test(f1_tan2s, f1_tans, paired = TRUE, alternative = "greater")
cat("p-valor test comparació (No Paramètric):", test_result$p.value, "\n") ###guanya 17 breaks

##MCC
diferenciesM_tans <- mcc_tan2s-mcc_tans
shapiro_test1 <- shapiro.test(diferenciesM_tans)
cat("p-valor Shapiro-Wilk:", shapiro_test1$p.value, "\n")
test_result <- t.test(mcc_tan2s, mcc_tans, paired = TRUE, alternative = "greater")
cat("p-valor test comparació (No Paramètric):", test_result$p.value, "\n") ###guanya 17 breaks

##MAE
diferenciesMa_tans <- mae_tan2s-mae_tans
shapiro_test <- shapiro.test(diferenciesMa_tans)
cat("p-valor Shapiro-Wilk:", shapiro_test$p.value, "\n")
test_result <- t.test(mae_tan2s, mae_tans, paired = TRUE, alternative = "less")
cat("p-valor test comparació (No Paramètric):", test_result$p.value, "\n") ###guanya 17 breaks

# 17 breaks tan vs 17 breaks nb

##ACC
diferencies17s <- acc_tan2s-acc_nb2s
shapiro_test2 <- shapiro.test(diferencies17s)
cat("p-valor Shapiro-Wilk:", shapiro_test2$p.value, "\n")
test_result <- t.test(acc_tan2s, acc_nb2s, paired = TRUE, alternative = "greater")
cat("p-valor test comparació (Paramètric):", test_result$p.value, "\n") ###guanya TAN de 17 breaks

##F1
diferenciesF17s <- f1_tan2s-f1_nb2s
shapiro_test2 <- shapiro.test(diferenciesF17s)
cat("p-valor Shapiro-Wilk:", shapiro_test2$p.value, "\n")
test_result <- t.test(f1_tan2s, f1_nb2s, paired = TRUE, alternative = "greater")
cat("p-valor test comparació (Paramètric):", test_result$p.value, "\n")

##MCC
diferenciesM17s <- mcc_tan2s-mcc_nb2s
shapiro_test2 <- shapiro.test(diferenciesM17s)
cat("p-valor Shapiro-Wilk:", shapiro_test2$p.value, "\n")
test_result <- t.test(mcc_tan2s, mcc_nb2s, paired = TRUE, alternative = "greater")
cat("p-valor test comparació (Paramètric):", test_result$p.value, "\n")

##MAE
diferenciesMa20s <- mae_tan2s-mae_nb2s
shapiro_test <- shapiro.test(diferenciesMa20s)
cat("p-valor Shapiro-Wilk:", shapiro_test$p.value, "\n")
test_result <- t.test(mae_tan2s, mae_nb2s, paired = TRUE, alternative = "less")
cat("p-valor test comparació (No Paramètric):", test_result$p.value, "\n") ###guanya 17 breaks

#################################################################
#3. Model final entrenat amb totes les dades  
#################################################################

tan_final_structure <- tree.bayes(data, "quality")
graphviz.plot(tan_final_structure, main = "Estructura Final Augmented Naive Bayes (TAN)") 
tan_final_fit <- bn.fit(tan_final_structure, data, method = "bayes", iss = 1)
tan_final_grain <- as.grain(tan_final_fit)
tan_final_grain <- compile(tan_final_grain)

forces <- arc.strength(tan_final_structure, data = data, criterion = "mi")
forces_ordenades <- forces[order(-forces$strength), ]
print(forces_ordenades)

tots_els_arcs <- bnlearn::arcs(tan_final_structure)
arcs_extra <- tots_els_arcs[tots_els_arcs[, "from"] != "quality", ]
print(arcs_extra)

#################################################################
#4. Prediccions per al model
#################################################################

nuevos_vinos_puntos <- data.frame(
  fixed.acidity = c(7.2, 6.5, 6.2, 6.4, 8.0, 10.2, 6.9),
  volatile.acidity = c(0.22, 0.25, 0.35, 0.26, 0.24, 1.10, 0.20),
  citric.acid = c(0.38, 0.30, 0.24, 0.35, 0.45, 0.00, 0.34),
  residual.sugar = c(1.5, 6.0, 2.0, 18.5, 2.5, 0.6, 4.5),
  chlorides = c(0.040, 0.045, 0.052, 0.038, 0.058, 0.200, 0.032),
  free.sulfur.dioxide = c(32, 40, 25, 48, 38, 2, 35),
  total.sulfur.dioxide = c(120, 150, 105, 180, 140, 15, 125),
  density = c(0.9898, 0.9951, 0.9888, 0.9990, 0.9908, 0.9985, 0.9905),
  pH = c(3.10, 3.25, 3.35, 3.20, 2.98, 3.82, 3.18),
  sulphates = c(0.45, 0.42, 0.58, 0.48, 0.50, 0.22, 0.52),
  alcohol = c(12.5, 9.5, 13.5, 10.0, 12.0, 8.5, 12.8),
  row.names = c("Verdejo_Joven", "Estilo_Pescadito", "Chardonnay_Crianza",
                "Blanco_Semidulce", "Blanco_Atlantico", "Vino_Picado", "Balance_Top")
)

predictors_continuos <- predictors
names(predictors_continuos) <- names(nuevos_vinos_puntos)

nuevos_vinos_disc <- nuevos_vinos_puntos

# Busquem valors dels predictors més propers per cada variable de cada nou cas i li assignem el seu interval.

for (var in names(nuevos_vinos_puntos)) {
  nuevos_vinos_disc[[var]] <- sapply(nuevos_vinos_puntos[[var]], function(x) {
    closest_idx <- which.min(abs(predictors_continuos[[var]] - x))
    return(as.character(data[closest_idx, var]))
  })
  nuevos_vinos_disc[[var]] <- factor(nuevos_vinos_disc[[var]], levels = levels(data[[var]]))
}

# Predicció de les qualitats dels perfils creats AMB PROBABILITATS

predicciones_list <- lapply(1:nrow(nuevos_vinos_disc), function(j) {
  evidencia <- as.list(nuevos_vinos_disc[j, ])
  
  xarxa_ev <- setEvidence(tan_final_grain,
                          nodes = names(evidencia),
                          states = as.character(unlist(evidencia)))
  
  prob_quality <- querygrain(xarxa_ev, nodes = "quality")$quality
  
  # 1. Agafem la classe guanyadora
  prediccio_max <- names(which.max(prob_quality))
  
  probs_df <- as.data.frame(t(round(prob_quality, 4)))
  colnames(probs_df) <- paste0("Prob_", colnames(probs_df))
  
  # 3. Ho unim en una sola fila
  cbind(data.frame(Prediccio_Calidad = prediccio_max), probs_df)
})

# Ajuntem la llista de resultats en una única taula final

taula_resultats <- do.call(rbind, predicciones_list)
rownames(taula_resultats) <- rownames(nuevos_vinos_puntos)

print(taula_resultats)