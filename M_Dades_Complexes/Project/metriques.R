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
  
  nivells_ordinals <- c("Baixa", "Mitjana", "Alta")
  real_num <- as.numeric(factor(real, levels = nivells_ordinals))
  pred_num <- as.numeric(factor(pred, levels = nivells_ordinals))
  error_absolut <- abs(real_num - pred_num)
  mae_per_classe <- sapply(clases, function(cl) {
    mean(error_absolut[real == cl], na.rm = TRUE)
  })
  
  metriques_class <- data.frame(
    Clase = clases,
    precissio = precissio,
    sensibilitat = sensibilitat,
    F1_score = f1,
    MAE_classe = mae_per_classe,
    N = rowSums(cm)
  )
  
  accuracy <- sum(tp) / n
  
  precissio_tot <- mean(precissio, na.rm = TRUE)
  sensibilitat_tot <- mean(sensibilitat, na.rm = TRUE)
  f1_macro <- mean(f1, na.rm = TRUE)
  
  c_val <- sum(tp)
  s <- n
  p_k <- colSums(cm)
  t_k <- rowSums(cm)
  
  numerador <- c_val*s-sum(p_k*t_k)
  denominador <- sqrt((s^2-sum(p_k^2))*(s^2-sum(t_k^2)))
  
  mcc <- ifelse(denominador==0, NA, numerador/denominador)
  mae_global <- mean(error_absolut, na.rm = TRUE)
  return(list(
    matriz_confusion = cm,
    accuracy = accuracy,
    precissio_tot = precissio_tot,
    sensibilitat_tot = sensibilitat_tot,
    f1_macro = f1_macro,
    mcc = mcc,
    mae = mae_global, 
    metriques_class = metriques_class
  ))
}

#################################################################################################
#################################################################################################
#################################################################################################
