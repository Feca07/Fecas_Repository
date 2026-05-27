library(haven)

uab_demo1 <- read_sas("uab_demo1.sas7bdat", NULL)
View(uab_demo1)

uab_drugs1 <- read_sas("uab_drugs1.sas7bdat", NULL)
View(uab_drugs1)

uab_atc_drugs1 <- read_sas("uab_atc_drugs1.sas7bdat",NULL)
View(uab_atc_drugs1)

library(naniar)
gg_miss_var(uab_demo1)


df_net=uab_demo1[!is.na(uab_demo1$Edat), ]
View(df_net)

summary(df_net)
library(psych)
describe(df_net)

