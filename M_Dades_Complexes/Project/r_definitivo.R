#################################################################
#0. Càrrega de dades
#################################################################
library(readr)
vino <- read_delim("C:/Users/ikerf/Downloads/TERCERO/SegundoCuatri/M_Dades_Complexes/Project/winequality-white.csv", 
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
predictores_disc <- discretize(predictores, method = "quantile", breaks = 6)
data <- cbind(predictores_disc, quality = vino$quality)

#Passem a factor totes les variables
data <- as.data.frame(lapply(data, as.factor))
summary(data)

#Funció per a calcular les mètriques:

calcular_metriques <- function(pred, real, nivells = levels(real)) {
  conf <- table(Predicted = pred, Real = real)
  cat("\nMatriu de confusió:\n")
  print(conf)
  
  accuracy <- sum(diag(conf)) / sum(conf)
  cat(sprintf("Accuracy: %.4f\n", accuracy))
  
  # Per cada classe
  precisio   <- numeric(length(nivells))
  sensibilitat <- numeric(length(nivells))
  f1           <- numeric(length(nivells))
  names(precisio) <- names(sensibilitat) <- names(f1) <- nivells
  
  for (cl in nivells) {
    TP <- conf[cl, cl]
    FP <- sum(conf[cl, ]) - TP      
    FN <- sum(conf[, cl]) - TP    
    
    precisio[cl]    <- ifelse((TP + FP) == 0, 0, TP / (TP + FP))
    sensibilitat[cl] <- ifelse((TP + FN) == 0, 0, TP / (TP + FN))
    f1[cl]           <- ifelse((precisio[cl] + sensibilitat[cl]) == 0, 0,
                               2 * precisio[cl] * sensibilitat[cl] /
                                 (precisio[cl] + sensibilitat[cl]))
  }
  
  cat("\nPrecisió per classe:\n");    print(round(precisio, 4))
  cat("Sensibilitat per classe:\n"); print(round(sensibilitat, 4))
  cat("F1-score per classe:\n");     print(round(f1, 4))
  cat(sprintf("Macro F1-score: %.4f\n", mean(f1)))
  
  invisible(list(conf = conf, accuracy = accuracy,
                 precisio = precisio, sensibilitat = sensibilitat, f1 = f1))
}




####
# FUNCIÓ AUXILIAR: predicció via gRain (obligatori per les instruccions)
####
prediu_grain <- function(grain_compilat, test, var_classe) {
  predictors <- names(test)[names(test) != var_classe]
  sapply(1:nrow(test), function(j) {
    obs      <- lapply(as.list(test[j, predictors]), as.character)
    grain_ev <- setEvidence(grain_compilat, nodes = names(obs), states = unlist(obs))
    probs    <- querygrain(grain_ev, nodes = var_classe)[[var_classe]]
    names(which.max(probs))
  })
}

####
# 2. K-fold cross-validation manual (k=10, sense caret)
####
set.seed(123)
k <- 10
n <- nrow(data)

# CORRECCIÓN: folds manuals sense createFolds de caret
folds <- sample(rep(1:k, length.out = n))

# Llistes per guardar prediccions i valors reals
pred_nb_list  <- vector("list", k)
real_nb_list  <- vector("list", k)
pred_ban_list <- vector("list", k)
real_ban_list <- vector("list", k)

# Whitelist BAN: quality pare de tots els predictors
wl <- data.frame(
  from = rep("quality", ncol(data) - 1),
  to   = names(data)[names(data) != "quality"]
)

for (i in 1:k) {
  cat(sprintf("Fold %d/%d...\n", i, k))
  train <- data[folds != i, ]
  test  <- data[folds == i, ]
  
  # ---- Naive Bayes ----
  nb_struct <- naive.bayes(train, training = "quality")
  nb_fit    <- bn.fit(nb_struct, train, method = "bayes")
  nb_grain  <- compile(as.grain(nb_fit))   # conversió a gRain (obligatori)
  
  pred_nb_list[[i]]  <- prediu_grain(nb_grain, test, "quality")
  real_nb_list[[i]]  <- as.character(test$quality)
  
  # ---- Augmented Naive Bayes (BAN) ----
  ban_struct <- hc(train, whitelist = wl)
  ban_fit    <- bn.fit(ban_struct, train, method = "bayes")
  ban_grain  <- compile(as.grain(ban_fit))  # conversió a gRain (obligatori)
  
  pred_ban_list[[i]]  <- prediu_grain(ban_grain, test, "quality")
  real_ban_list[[i]]  <- as.character(test$quality)
}

# Unir resultats mantenint nivells
nivells <- levels(data$quality)
pred_nb  <- factor(unlist(pred_nb_list),  levels = nivells)
real_nb  <- factor(unlist(real_nb_list),  levels = nivells)
pred_ban <- factor(unlist(pred_ban_list), levels = nivells)
real_ban <- factor(unlist(real_ban_list), levels = nivells)

####
# 3. Mètriques i comparació
####
cat("\n========== NAIVE BAYES ==========\n")
met_nb <- calcular_metriques(pred_nb, real_nb)

cat("\n========== AUGMENTED NAIVE BAYES (BAN) ==========\n")
met_ban <- calcular_metriques(pred_ban, real_ban)

####
# 5. Model final (entrenat amb totes les dades)
#    Usar el millor classificador escollit a partir de la validació
####
cat("\n========== MODEL FINAL ==========\n")

# Escull el millor model (canvia 'ban' per 'nb' si NB és millor)
ban_struct_final <- hc(data, whitelist = wl)
ban_fit_final    <- bn.fit(ban_struct_final, data, method = "bayes")
ban_grain_final  <- compile(as.grain(ban_fit_final))

# Visualitzar estructura apresa
plot(ban_struct_final, main = "Estructura BAN final (totes les dades)")




















































#################################################################
# 2. Naive Bayes amb k-fold cross-validation (k=10)
#################################################################
library(gRain)
set.seed(123)
k <- 100
n <- nrow(data)
folds <- sample(rep(1:k, length.out = n))  # assignar cada obs a un fold

# Vectors per guardar prediccions i valors reals
pred_nb  <- factor(levels = levels(data$quality))
real_nb  <- factor(levels = levels(data$quality))

for (i in 1:k) {
  train <- data[folds != i, ]
  test  <- data[folds == i, ]
  
  # Aprendre estructura Naive Bayes
  nb <- naive.bayes(train, training = "quality")
  
  # Aprendre parametres
  nb_fit <- bn.fit(nb, train, method = "bayes")  # method="bayes" evita prob 0
  
  # Prediccions
  pred_i <- predict(nb_fit, test)
  
  pred_nb <- c(pred_nb, pred_i)
  real_nb <- c(real_nb, test$quality)
}

# Matriu de confusió manual
conf_nb <- table(Predicted = pred_nb, Real = real_nb)
print(conf_nb)

# Accuracy
accuracy_nb <- sum(diag(conf_nb)) / sum(conf_nb)
cat("Accuracy Naive Bayes:", round(accuracy_nb, 4), "\n")


#################################################################
# 3. Augmented Naive Bayes (BAN) amb k-fold cross-validation (k=10)
#    Estructura apresa amb hc() forçant quality com a pare de tots
#################################################################
library(gRain)
set.seed(123)
pred_ban <- c()
real_ban <- c()

# Whitelist: quality ha de ser pare de tots els predictors
wl <- data.frame(
  from = rep("quality", length(names(data)) - 1),
  to   = names(data)[names(data) != "quality"]
)

for (i in 1:k) {
  train <- data[folds != i, ]
  test  <- data[folds == i, ]
  
  # 1. Aprendre estructura BAN amb Hill-Climbing + whitelist
  ban_struct <- hc(train, whitelist = wl)
  
  # 2. Aprendre parametres (Bayesian per evitar prob = 0)
  ban_fit <- bn.fit(ban_struct, train, method = "bayes")
  
  # 3. Convertir a format gRain (tal com demanen les instruccions)
  ban_grain <- as.grain(ban_fit)
  ban_grain <- compile(ban_grain)
  
  # 4. Predicció cas a cas via gRain
  pred_i <- sapply(1:nrow(test), function(j) {
    # Evidència: tots els predictors menys quality
    obs <- as.list(test[j, names(test) != "quality"])
    obs <- lapply(obs, as.character)
    
    # Introduir evidència i consultar P(quality | evidència)
    grain_ev <- setEvidence(ban_grain, 
                            nodes   = names(obs), 
                            states  = unlist(obs))
    probs <- querygrain(grain_ev, nodes = "quality")$quality
    
    # Classe amb probabilitat màxima
    names(which.max(probs))
  })
  
  pred_ban <- c(pred_ban, pred_i)
  real_ban <- c(real_ban, as.character(test$quality))
}

# Convertir a factor amb els mateixos nivells
pred_ban <- factor(pred_ban, levels = levels(data$quality))
real_ban <- factor(real_ban, levels = levels(data$quality))

# Matriu de confusió BAN
conf_ban <- table(Predicted = pred_ban, Real = real_ban)
print(conf_ban)

# Accuracy BAN
accuracy_ban <- sum(diag(conf_ban)) / sum(conf_ban)
cat("Accuracy BAN:", round(accuracy_ban, 4), "\n")
