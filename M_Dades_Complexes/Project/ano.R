library(readr)
data <- read_csv("C:/Users/ikerf/Downloads/TERCERO/SegundoCuatri/M_Dades_Complexes/Project/estres/Teen_Mental_Health_Dataset.csv")
View(data)

length(data$age)
data$gender=as.factor(data$gender)
data$platform_usage=as.factor(data$platform_usage)
data$social_interaction_level=as.factor(data$social_interaction_level)
data$platform_usage=as.factor(data$platform_usage)
data$stress_level=as.factor(data$stress_level)
data$anxiety_level=as.factor(data$anxiety_level)
data$addiction_level=as.factor(data$addiction_level)
data$depression_label=as.factor(data$depression_label)

summary(data)
table(data$anxiety_level,data$depression_label)
### sense agrupar

### hacer 1 xarxa (p.ej: naive bayes) para cada y_i, y hacer un modelo de multiclase donde x_i no van a y_i

"1,2,3 Mayo"

hist(data$social_interaction_level)
plot(data$social_interaction_level)
hist(data$physical_activity)
