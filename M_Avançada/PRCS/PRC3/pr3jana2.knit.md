---
title: "Pràctica 3 : Cas-control per avaluar  la relació entre exposició a fàrmacs 
antidepressius i fractura de maluc (Disseny aparellat)."
author:
- Iker Fernandez (1704341)
- Enola Garcia (1708253)
- Didac Campuzano (1703766)
- Marta Baurier (1668618)
- Jana Labrador (1704595)
date: "2026-04-22"
output:
  pdf_document:
    number_sections: true
    extra_dependencies: float
  html_document: default
  word_document: default
bibliography: referencia.bib
link-citations: true
---



L'objectiu d'aquest estudi és avaluar l'associació entre l'exposició a fàrmacs antidepressius i el risc de fractura de maluc. En aquesta anàlisi, s'han descartat els controls hospitalaris previs per utilitzar nous controls procedents d'atenció primària, aparellats en una relació 1:4 per edat, sexe, centre i data de consulta. Això permet treballar amb una població de referència més coherent, millorant la validesa externa dels resultats


Creuem les dades de totes les bases de dades, el codi el podem veure a l'annex\footnote{Annex \ref{anx:carrega}}



La Taula \ref{tab:tab1} mostra els estadístics descriptius de les característiques de la població segons el grup d’estudi (controls i casos). Per a les variables categòriques es presenten les freqüències absolutes i els percentatges, mentre que per a les variables quantitatives es mostren les mitjanes i les desviacions estàndard.




\begin{longtable}[t]{llccc}
\caption{\label{tab:unnamed-chunk-1}\label{tab:tab1}Característiques de la població}\\
\toprule
 & Control & Cas & P\_valor & \\
\midrule
n & 524 & 131 &  & \\
Sexe = M (\%) & 108 (20.6) & 27 (20.6) & 1.000 & \\
Edat (\%) &  &  & 1.000 & \\
\hspace{1em}51-65 & 28 ( 5.3) & 7 ( 5.3) &  & \\
\hspace{1em}66-81 & 172 (32.8) & 43 (32.8) &  & \\
\addlinespace
\hspace{1em}82-95 & 324 (61.8) & 81 (61.8) &  & \\
PES (mean (SD)) & 67.53 (13.04) & 64.84 (11.68) & 0.173 & \\
TALLA (mean (SD)) & 155.47 (8.02) & 152.36 (7.83) & 0.036 & \\
IMC (mean (SD)) & 27.76 (4.83) & 27.55 (4.90) & 0.809 & \\
Smoker (\%) &  &  & 0.001 & \\
\addlinespace
No Fumador & 502 (95.8) & 117 (89.3) &  & \\
\hspace{1em}Fumador Actiu & 16 ( 3.1) & 6 ( 4.6) &  & \\
\hspace{1em}Ex-Fumador & 6 ( 1.1) & 8 ( 6.1) &  & \\
\hspace{1em}ALCOHOL (\%) &  &  & 0.058 & \\
No consumeix & 465 (88.7) & 123 (93.9) &  & \\
\addlinespace
\hspace{1em}Poc consum & 56 (10.7) & 6 ( 4.6) &  & \\
\hspace{1em}Consum moderat & 3 ( 0.6) & 2 ( 1.5) &  & \\
\hspace{1em}Artritis\_reumatoide = 1 (\%) & 5 ( 1.0) & 1 ( 0.8) & 1.000 & \\
Fractura = 1 (\%) & 2 ( 0.4) & 55 (42.0) & <0.001 & \\
NFractura (\%) &  &  & <0.001 & \\
\addlinespace
0 & 522 (99.6) & 76 (58.0) &  & \\
\hspace{1em}1 & 2 ( 0.4) & 48 (36.6) &  & \\
\hspace{1em}>=2 & 0 ( 0.0) & 7 ( 5.3) &  & \\
\hspace{1em}Diabetis = 1 (\%) & 118 (22.5) & 45 (34.4) & 0.007 & \\
tipus\_diabetis (\%) &  &  & 0.007 & \\
\addlinespace
No diabetis & 406 (77.5) & 86 (65.6) &  & \\
\hspace{1em}Tipus 1 & 4 ( 0.8) & 0 ( 0.0) &  & \\
\hspace{1em}Tipus 2 & 114 (21.8) & 45 (34.4) &  & \\
\hspace{1em}Osteporosi = 1 (\%) & 13 ( 2.5) & 17 (13.0) & <0.001 & \\
Densitometries = 1 (\%) & 0 ( 0.0) & 8 ( 6.1) & <0.001 & \\
\addlinespace
neoplasia = 1 (\%) & 61 (11.6) & 12 ( 9.2) & 0.514 & \\
HiperTiroidisme = 1 (\%) & 3 ( 0.6) & 4 ( 3.1) & 0.046 & \\
Malnutricio = 1 (\%) & 1 ( 0.2) & 3 ( 2.3) & 0.033 & \\
Malabsorcio = 1 (\%) & 1 ( 0.2) & 0 ( 0.0) & 1.000 & \\
Malaltia\_Hep\_Cro = 1 (\%) & 7 ( 1.3) & 5 ( 3.8) & 0.126 & \\
\addlinespace
OthRiskFract = 1 (\%) & 75 (14.3) & 22 (16.8) & 0.564 & \\
CountActualGE4 = 1 (\%) & 222 (42.4) & 99 (75.6) & <0.001 & \\
\bottomrule
\end{longtable}

Cal destacar que diverses variables presenten una proporció elevada de valors perduts (NA). Tot i que aquestes variables s’han inclòs en l’anàlisi descriptiva, els seus resultats s’han d’interpretar amb cautela, ja que aquest alt contingut de dades mancants pot limitar la seva fiabilitat i representativitat. Per aquest motiu, en la interpretació global no es dona el mateix pes a totes les variables.

En general, la majoria de variables presenten distribucions similars entre els grups de casos i controls, sense diferències estadísticament significatives. Això s’observa, per exemple, en variables com el sexe, l’edat, el MatchCC, l’IMC o la presència de neoplàsia, on els valors són molt semblants entre ambdós grups.

Tanmateix, s’observen diferències estadísticament significatives en algunes variables com el servei d’alta, la talla, el consum de tabac (Smoker), la presència de fractura i el nombre de fractures, la diabetis i el tipus de diabetis, l’osteoporosi, la realització de densitometries, l’hipertiroïdisme, la malnutrició i la variable CountActualGE4.

Pel que fa als mètodes estadístics utilitzats, per a les variables categòriques s’han aplicat proves de comparació de proporcions, principalment el test de chi-quadrat o el test exacte de Fisher quan les freqüències eren baixes. Per a les variables quantitatives s’ha utilitzat el test no paramètric de Wilcoxon (Mann-Whitney), adequat en situacions on no es pot assumir normalitat en la distribució de les dades.

Un element destacable és que variables directament relacionades amb el resultat, com la fractura i el nombre de fractures, presenten diferències molt marcades entre casos i controls, fet esperable atès que formen part de la definició dels grups. També s’observa una major prevalença d’algunes condicions clíniques com la diabetis o l’osteoporosi en els casos, la qual cosa podria suggerir una possible associació amb el risc de fractura.

No obstant això, aquesta anàlisi és purament descriptiva i no té en compte possibles factors de confusió. A més, la presència de dades mancants en algunes variables pot introduir incertesa en les estimacions. Per tant, el fet que una variable presenti una major proporció en un grup no implica necessàriament una relació causal. Per aquest motiu, en les anàlisis posteriors es durà a terme una regressió logística, tant en forma crua com ajustada per covariables, per tal d’avaluar aquestes associacions de manera més robusta.

\clearpage
# Analitzar la exposició als fàrmacs i els riscs associats de fractura

## Anàlisi descriptiva d'exposició en els grups de cas i control

La taula \ref{tab:descrip} mostra la distribució dels diferents fàrmacs i grups terapèutics entre casos i controls, permetent comparar el percentatge d'exposició en ambdós grups.




Table: \label{tab:descrip}Comparació de Medicaments i teràpies

|                         |Control    |    Cas    | P_valor |   |
|:------------------------|:----------|:---------:|:-------:|:-:|
|n                        |524        |    131    |         |   |
|CortInh = 1 (%)          |25 ( 4.8)  | 15 (11.5) |  0.008  |   |
|CortSist = 1 (%)         |6 ( 1.1)   | 5 ( 3.8)  |  0.080  |   |
|CortSistIniBf3m = 1 (%)  |6 ( 1.1)   | 3 ( 2.3)  |  0.557  |   |
|CortSistExpLt3m = 1 (%)  |6 ( 1.1)   | 3 ( 2.3)  |  0.557  |   |
|CortInhIniBf3m = 1 (%)   |20 ( 3.8)  | 10 ( 7.6) |  0.102  |   |
|CortInhExpLt3m = 1 (%)   |20 ( 3.8)  | 10 ( 7.6) |  0.102  |   |
|ADO_no_glitazona = 1 (%) |47 ( 9.0)  | 26 (19.8) |  0.001  |   |
|Bisf = 1 (%)             |15 ( 2.9)  | 17 (13.0) | <0.001  |   |
|ADepreISRS = 1 (%)       |40 ( 7.6)  | 36 (27.5) | <0.001  |   |
|ADepreNoISRS = 1 (%)     |48 ( 9.2)  | 30 (22.9) | <0.001  |   |
|insulina = 1 (%)         |20 ( 3.8)  | 10 ( 7.6) |  0.102  |   |
|H_SN = 1 (%)             |30 ( 5.7)  | 15 (11.5) |  0.034  |   |
|N_SN = 1 (%)             |223 (42.6) | 99 (75.6) | <0.001  |   |
|H01_SN = 1 (%)           |1 ( 0.2)   | 0 ( 0.0)  |  1.000  |   |
|H02_SN = 1 (%)           |7 ( 1.3)   | 5 ( 3.8)  |  0.126  |   |
|N06_SN = 1 (%)           |83 (15.8)  | 55 (42.0) | <0.001  |   |
|N06A_SN = 1 (%)          |66 (12.6)  | 50 (38.2) | <0.001  |   |
|N06AA_SN = 1 (%)         |9 ( 1.7)   | 4 ( 3.1)  |  0.528  |   |
|N06AB_SN = 1 (%)         |41 ( 7.8)  | 36 (27.5) | <0.001  |   |
|N06AX_SN = 1 (%)         |21 ( 4.0)  | 15 (11.5) |  0.002  |   |
|R03BA_SN = 1 (%)         |7 ( 1.3)   | 2 ( 1.5)  |  1.000  |   |

Els resultats de l’anàlisi descriptiva mostren diferències significatives entre casos i controls en diversos grups farmacològics. En particular, destaca una major prevalença d’ús d’antidepressius en el grup de casos, tant per als ISRS com per als no ISRS. Els ISRS presenten una prevalença del 27,5% en casos enfront del 7,6% en controls, i els antidepressius no ISRS del 22,9% davant del 9,2%, amb p-valors significatius en tots dos casos. Aquest mateix patró també s’observa en diverses categories del sistema nerviós, com N06, N06A i N06AB.

També s’observen diferències significatives en altres grups terapèutics, com els bifosfonats o els antidiabètics orals, fet que suggereix una major càrrega terapèutica en el grup de casos.

En aquest sentit, [@coupland2011antidepressant] assenyalen que l’associació entre antidepressius i esdeveniments adversos pot estar parcialment explicada per les característiques dels pacients tractats. Aquest fet encaixa amb els nostres resultats, perquè a la taula veiem que els casos prenen més antidepressius que els controls, sobretot ISRS i antidepressius no ISRS, tal com hem esmentat.

Per altra banda, veiem que els casos prenen més fàrmacs del sistema nerviós, sobretot antidepressius. Segons la [@brotomodulo], aquest tipus de pacients sovint presenten polimedicació, i això augmenta el risc d’efectes adversos i d’interaccions entre medicaments; és per això que cal interpretar-ho amb prudència.

Per tant, serà necessari realitzar una anàlisi multivariant per determinar si aquestes associacions es mantenen després d’ajustar per possibles factors confusors.

\clearpage
## Anàlisi inferencial cru i ajustat

A continuació, utilitzarem un model de Regressió Logística Condicional, fent servir la funció `clogit` del paquet `survival`. S'utilitza aquest tipus de model degut a que parlem d'un estudi Cas-Control, on les dades son pariades, en aquest cas, 1:4, és a dir, cada cas té 4 controls, aparellats en edat i sexe.

I per tant, les observacions dins de cada conjunt de 4 són dependents, això fa que la regressió logística convencional no sigui adequada en aquest cas.

### Anàlisi logística "crua"

La taula \ref{tab:logcru} presenta els resultats de la regressió logística crua, que permet veure l'associació directa entre l'exposició als diferents fàrmacs i el risc de fractura de maluc, sense ajustar per possibles factors de confusió.




Table: \label{tab:logcru}Anàlisi per regressió logística crua de les variables

|Variable         | OR_Cru | IC_Inferior | IC_Superior |P_valor |
|:----------------|:------:|:-----------:|:-----------:|:-------|
|CortInh          |  2.40  |    1.27     |    4.55     |0.007   |
|CortSist         |  3.33  |    1.02     |    10.92    |0.047   |
|CortSistIniBf3m  |  2.00  |    0.50     |    8.00     |0.327   |
|CortSistExpLt3m  |  2.00  |    0.50     |    8.00     |0.327   |
|CortInhIniBf3m   |  2.00  |    0.94     |    4.27     |0.074   |
|CortInhExpLt3m   |  2.00  |    0.94     |    4.27     |0.074   |
|ADO_no_glitazona |  2.56  |    1.50     |    4.37     |0.001   |
|Bisf             |  4.94  |    2.39     |    10.21    |0.000   |
|ADepreISRS       |  5.15  |    2.97     |    8.93     |0.000   |
|ADepreNoISRS     |  3.13  |    1.85     |    5.30     |0.000   |
|insulina         |  2.08  |    0.95     |    4.56     |0.066   |
|H_SN             |  2.11  |    1.10     |    4.03     |0.024   |
|N_SN             |  4.32  |    2.77     |    6.74     |0.000   |
|H01_SN           |  0.00  |    0.00     |     Inf     |0.997   |
|H02_SN           |  2.86  |    0.91     |    9.00     |0.073   |
|N06_SN           |  4.16  |    2.65     |    6.52     |0.000   |
|N06A_SN          |  4.58  |    2.87     |    7.31     |0.000   |
|N06AA_SN         |  1.83  |    0.54     |    6.14     |0.329   |
|N06AB_SN         |  4.93  |    2.87     |    8.49     |0.000   |
|N06AX_SN         |  2.98  |    1.51     |    5.90     |0.002   |
|R03BA_SN         |  1.14  |    0.24     |    5.50     |0.868   |


Els resultats mostren una associació positiva i estadísticament significativa entre diversos fàrmacs i el risc de fractura de maluc. A diferència d’altres dissenys amb controls hospitalaris, l’ús de controls de població general podria contribuir a una major diferència en el perfil d’exposició entre casos i controls.

Els resultats més destacats es troben en els **antidepressius** (`N06_SN`), amb una OR crua de 4.16 (IC: 2.65, 6.52). Dins d'aquest grup, els ISRS (`N06AB_SN`) presenten el risc més eleva, amb una OR de  4.93, en línia amb el que descriu l'article de referència [@gorgas2021], que siggereix tant un augmet del risc de caigudes com possibles efectes sobre el metabolisme ossi.

També s'observen riscos molt elevats en els **bisfosfonats** (OR=4.94). Aquestes associacions s'han d'interpretar amb precaució, ja que poden reflectir confusió per indicació: els pacients exposats són probablement més fràgils o amb més patologies de base (com osteoporosi o diabetis) que els controls. Aquesta gran diferència basal explica per què les OR crues són tan elevades en comparació amb estudis on els controls també estan malalts.

D’altra banda, algunes variables no mostren associacions estadísticament significatives, com la insulina (p=0.066) o determinats subgrups terapèutics. Finalment, la presència d’intervals de confiança molt amplis o valors extrems, com en H01_SN, indica possibles problemes de baixa freqüència o separació quasi perfecta, fet que limita la fiabilitat d’aquestes estimacions.

### Anàlisi logística ajustada

L'anàlisi crua detecta un increment de risc generalitzat, però la magnitud d'aquestes OR suggereix la presència d'un fort biaix de confusió per indicació. Per tant, l'anàlisi ajustada que es veu a continuació, és imprescindible per intentar aïllar l'efecte real dels antidepressius de la fragilitat general del pacient.

Per tal de fer el millor ajust possible, observem la taula \ref{tab:tab1} per observar possibles variables confusores, i tenim que aquestes són: 

-   **Variables confusores retingudes**

- `Smoker` i `Alcohol`: S’ha decidit incloure aquestes variables en l’anàlisi ajustat ja que són factors d'estil de vida que afecten directament la salut òssia i poden actuar com a variables de confusió en l'associació amb els medicaments [@leal2022description] [@botaya2018osteoporosis]. A la descripció basal (\ref{tab:tab1}), s’observen diferències estadísticament significatives en el consum de tabac (p=0.001), amb una major proporció de fumadors actius i ex-fumadorsa l grup dels casos. Pel que fa a l’alcohol (p=0,058), tot i trobar-se en el límit de la significació, s'ha optat per mantenir-la al model ajustat per la seva rellevància clínica i bibliogràfica en el risc de fractures i caigudes, a més, aquesta diferéncia es troba als controls en l'àmbit de poc consum.

- `Diabetis`, `CountActualGE4`: De manera similar, es va avaluar l'impacte de prendre 4 o més fàrmacs de risc (CountActualGE4), ja que pot actuar com a indicador de polimedicació i de major càrrega de comorbiditat [@bonaga2016polifarmacia]. En la descripció basal (\ref{tab:tab1}), aquesta variable mostra diferències estadísticament significatives entre casos i controls( p<0.001), amb una major proporció de pacients polimedicats en el grup de casos (75.6% vs 42.4%).

Pel que fa a la diabetis, també s’observen diferències significatives (p=0.007), amb una major prevalença en els casos. Donada la seva relació amb complicacions metabòliques i possibles efectes sobre el risc de fractura, així com l’ús de tractaments com la insulina i altres antidiabètics [@sedlinskydiabetes], es considera una variable rellevant a incloure com a covariable en el model ajustat.

- `Osteoporosi` i `Fractura`: Compleixen un doble criteri. D'una banda, presenten una forta evidència clínica com a factors de risc directes per a futures fractures. L'osteporosi és una malaltia que debilita els ossos i augmenta el risc de fractures i, Fractura indica si han hagut fractures prèvies [@campos2019osteoporosis]. D'altra banda, l'anàlisi de comparació de grups confirma una diferència estadísticament significativa en la nostra mostra d'estudi.

- **Variables avaluades i excloses**:

- `Talla`, `HiperTiroidisme` i `Malnutricio`: La variable talla, ha estat exclosa degut a la presència de NA's a la base de dades, cosa que fa que els resultats s'esbiaixin. Per la part de l' HiperTiroidisme i la Malnutricio, tot i que hii ha diferencies significatives, s'ha optat per no incloure-les ja que aquestes tenen una baixa freqüència d'aquestes als casos i controls, la introducció d'aquestes variables podria generar problemes d'inestabilitat numèrica, a més, s'ha considerat que el seu potencial com a confusor, pot estar bastant limitat.

Per tant, un cop s'han triat els confusors, fem el model:




Table: \label{tab:logajust}Anàlisi per regressió logística ajustada per covariables

|Variable         | OR_Ajustat | IC_Inferior | IC_Superior | P_valor |
|:----------------|:----------:|:-----------:|:-----------:|:-------:|
|CortInh          |    1.78    |    0.69     |    4.61     |  0.233  |
|CortSist         |    3.94    |    0.83     |    18.74    |  0.085  |
|CortSistIniBf3m  |    3.09    |    0.58     |    16.50    |  0.188  |
|CortSistExpLt3m  |    3.09    |    0.58     |    16.50    |  0.188  |
|CortInhIniBf3m   |    1.60    |    0.55     |    4.66     |  0.393  |
|CortInhExpLt3m   |    1.60    |    0.55     |    4.66     |  0.393  |
|ADO_no_glitazona |    1.40    |    0.53     |    3.72     |  0.495  |
|Bisf             |    1.64    |    0.42     |    6.41     |  0.477  |
|ADepreISRS       |    3.72    |    1.62     |    8.54     |  0.002  |
|ADepreNoISRS     |    1.62    |    0.72     |    3.67     |  0.245  |
|insulina         |    1.29    |    0.40     |    4.11     |  0.668  |
|H_SN             |    1.21    |    0.48     |    3.07     |  0.681  |
|N_SN             |    2.86    |    1.31     |    6.25     |  0.008  |
|H01_SN           |    0.00    |    0.00     |     Inf     |  0.997  |
|H02_SN           |    3.00    |    0.70     |    12.81    |  0.138  |
|N06_SN           |    2.34    |    1.17     |    4.70     |  0.017  |
|N06A_SN          |    2.36    |    1.16     |    4.81     |  0.018  |
|N06AA_SN         |    0.92    |    0.12     |    6.99     |  0.935  |
|N06AB_SN         |    3.47    |    1.53     |    7.84     |  0.003  |
|N06AX_SN         |    0.79    |    0.24     |    2.59     |  0.696  |
|R03BA_SN         |    1.69    |    0.25     |    11.32    |  0.590  |

Els resultats de la regressió logística ajustada mostren una reducció general de les odds ratio respecte a l’anàlisi crua, fet que suggereix la presència de confusió per indicació en molts dels fàrmacs analitzats. Després d’ajustar per covariables com diabetis, alcohol, tabaquisme i osteoporosi, la majoria d’associacions perden significació estadística.

Els resultats més destacats es mantenen en els antidepressius, especialment dins del grup N06, amb una OR ajustada de 2.34 (IC: 1.17, 4.70). Dins d’aquest grup, els ISRS (N06AB) continuen presentant una associació significativa (OR=3.47; IC: 1.53, 7.84), fet que reforça la hipòtesi d’un possible efecte propi d’aquests fàrmacs més enllà del perfil basal dels pacients.

En canvi, altres fàrmacs que mostraven associacions elevades en l’anàlisi crua, com els bisfosfonats o la insulina, deixen de ser estadísticament significatius després de l’ajust. Això suggereix que les associacions observades inicialment podrien estar influïdes per la presència de factors de confusió.

## Comparació amb l'article

Els resultats obtinguts en aquest estudi són, en general, similars amb els descrits a l'article de referència [@gorgas2021], tant en l'anàlisi crua com en l'ajustada.

Pel que fa a l'anàlisi crua, les magnituds de les odds ratio són molt similars entre ambdós estudis. En particular, els antidepressius, especialment els ISRS (N06AB), mostren una OR elevada tant en el nostre estudi (OR =4.93) com en l'article (OR=4.89), indicant una forta associació entre exposició i risc de fractura abans d'ajustar per factors de confusió.

En l'anàlisi ajustada, es manté aquesta coherència. Els ISRS continuen mostrant una associació positiva i estadísticament significativa en ambdós estudis, amb una OR de 3.47 en els nostres resultats i de 3.52 en l'article. 

Altres antidepressius no ISRS perden significació estadística després de l'ajust en ambdós estudis, suggerint que l'associació observada en l'anàlisi crua està influïda per factors de confusió.

Les petites diferències observades entre els resultats poden deure's a variacions en les covariables incloses en el model, cosa que podria explicar les discrepàncies observades entre ambdós estudis.

\clearpage
# Estadístics descriptius, mesures de risc, inferencies...



Table: Exposició a fàrmacs i riscos associats

|Exposure         | Controls n (%) | Casos n (%) |  OR crua (IC95%); p valor  | OR ajustada (IC95%); p valor |
|:----------------|:--------------:|:-----------:|:--------------------------:|:----------------------------:|
|CortInh          |   25 ( 4.8)    |  15 (11.5)  |  2.4 (1.27,4.55); p=0.007  |  1.78 (0.69,4.61); p=0.233   |
|CortSist         |    6 ( 1.1)    |  5 ( 3.8)   | 3.33 (1.02,10.92); p=0.047 |  3.94 (0.83,18.74); p=0.085  |
|CortSistIniBf3m  |    6 ( 1.1)    |  3 ( 2.3)   |   2 (0.5,8.00); p=0.327    |  3.09 (0.58,16.50); p=0.188  |
|CortSistExpLt3m  |    6 ( 1.1)    |  3 ( 2.3)   |   2 (0.5,8.00); p=0.327    |  3.09 (0.58,16.50); p=0.188  |
|CortInhIniBf3m   |   20 ( 3.8)    |  10 ( 7.6)  |   2 (0.94,4.27); p=0.074   |   1.6 (0.55,4.66); p=0.393   |
|CortInhExpLt3m   |   20 ( 3.8)    |  10 ( 7.6)  |   2 (0.94,4.27); p=0.074   |   1.6 (0.55,4.66); p=0.393   |
|ADO_no_glitazona |   47 ( 9.0)    |  26 (19.8)  |  2.56 (1.5,4.37); p=0.001  |   1.4 (0.53,3.72); p=0.495   |
|Bisf             |   15 ( 2.9)    |  17 (13.0)  |   4.94 (2.39,10.21); p=0   |  1.64 (0.42,6.41); p=0.477   |
|ADepreISRS       |   40 ( 7.6)    |  36 (27.5)  |   5.15 (2.97,8.93); p=0    |  3.72 (1.62,8.54); p=0.002   |
|ADepreNoISRS     |   48 ( 9.2)    |  30 (22.9)  |   3.13 (1.85,5.30); p=0    |  1.62 (0.72,3.67); p=0.245   |
|insulina         |   20 ( 3.8)    |  10 ( 7.6)  | 2.08 (0.95,4.56); p=0.066  |   1.29 (0.4,4.11); p=0.668   |
|H_SN             |   30 ( 5.7)    |  15 (11.5)  |  2.11 (1.1,4.03); p=0.024  |  1.21 (0.48,3.07); p=0.681   |
|N_SN             |   223 (42.6)   |  99 (75.6)  |   4.32 (2.77,6.74); p=0    |  2.86 (1.31,6.25); p=0.008   |
|H01_SN           |    1 ( 0.2)    |  0 ( 0.0)   |     0 (0,Inf); p=0.997     |      0 (0,Inf); p=0.997      |
|H02_SN           |    7 ( 1.3)    |  5 ( 3.8)   | 2.86 (0.91,9.00); p=0.073  |    3 (0.7,12.81); p=0.138    |
|N06_SN           |   83 (15.8)    |  55 (42.0)  |   4.16 (2.65,6.52); p=0    |  2.34 (1.17,4.70); p=0.017   |
|N06A_SN          |   66 (12.6)    |  50 (38.2)  |   4.58 (2.87,7.31); p=0    |  2.36 (1.16,4.81); p=0.018   |
|N06AA_SN         |    9 ( 1.7)    |  4 ( 3.1)   | 1.83 (0.54,6.14); p=0.329  |  0.92 (0.12,6.99); p=0.935   |
|N06AB_SN         |   41 ( 7.8)    |  36 (27.5)  |   4.93 (2.87,8.49); p=0    |  3.47 (1.53,7.84); p=0.003   |
|N06AX_SN         |   21 ( 4.0)    |  15 (11.5)  | 2.98 (1.51,5.90); p=0.002  |  0.79 (0.24,2.59); p=0.696   |
|R03BA_SN         |    7 ( 1.3)    |  2 ( 1.5)   | 1.14 (0.24,5.50); p=0.868  |  1.69 (0.25,11.32); p=0.59   |


# Factors de confusió

Els factors de confusió són variables que fan que una relació aparent entre un fàrmac i el risc de fractura pugui estar influïda, en realitat, per característiques dels pacients i no únicament per l’efecte del tractament.

En aquest estudi, la Taula 1 i la Taula 2 ja mostren diferències entre casos i controls en diverses variables clíniques i d’estil de vida. També s’observa que diversos medicaments són més freqüents en el grup de casos, especialment antidepressius, bisfosfonats i antidiabètics. Tot i això, aquestes diferències descriptives no permeten concloure una relació causal directa.

La comparació entre la Taula 3 (anàlisi crua) i la Taula 4 (anàlisi ajustada) permet valorar millor la presència de confusió. Quan una odds ratio disminueix de manera notable després de l’ajust o deixa de ser significativa, això suggereix que part de l’associació inicial estava influïda per factors de confusió.

En aquest cas, els bisfosfonats passen d’una OR crua elevada a una OR ajustada molt menor i no significativa. Aquest patró és coherent amb confusió per indicació, ja que els pacients que reben aquest tractament presenten amb més freqüència osteoporosi o major risc ossi previ. Un comportament similar s’observa en la insulina i altres tractaments metabòlics, on la càrrega de comorbiditat podria explicar part de l’excés de risc observat en l’anàlisi no ajustada.

Cal destacar també que la pèrdua de significació després de l’ajust no vol dir necessàriament que no hi hagi efecte, sinó que l’efecte estimat pot ser més petit, menys precís o ambdues coses alhora. Que els intervals de confiança siguin més amplis després d’afegir covariables és habitual en models amb diverses variables, especialment quan la mostra no és molt gran.

Finalment, no es pot descartar la presència de confusió residual per factors que no estan disponibles a la base de dades, com antecedents de caigudes, estat funcional, gravetat clínica, dosi acumulada o adherència al tractament. Per això, els resultats s’han d’interpretar com associacions ajustades i no com una prova causal definitiva. Tot i així, l’ús de regressió logística condicional en un disseny aparellat continua sent una opció adequada per obtenir resultats més fiables en aquest context.



Table: Avaluació de factors de confusió mitjançant el canvi relatiu de l'OR

|Variable         | OR Cru | OR Ajustat | Canvi relatiu (%) | Confusora? |Direcció                  |
|:----------------|:------:|:----------:|:-----------------:|:----------:|:-------------------------|
|CortInh          |  2.40  |    1.80    |       33.3        | Sí (+10%)  |Positiva (sobreestimació) |
|CortSist         |  3.33  |    3.93    |       -15.3       | Sí (+10%)  |Negativa (subestimació)   |
|CortSistIniBf3m  |  2.00  |    3.05    |       -34.4       | Sí (+10%)  |Negativa (subestimació)   |
|CortSistExpLt3m  |  2.00  |    3.05    |       -34.4       | Sí (+10%)  |Negativa (subestimació)   |
|CortInhIniBf3m   |  2.00  |    1.61    |       24.2        | Sí (+10%)  |Positiva (sobreestimació) |
|CortInhExpLt3m   |  2.00  |    1.61    |       24.2        | Sí (+10%)  |Positiva (sobreestimació) |
|ADO_no_glitazona |  2.56  |    1.40    |       82.9        | Sí (+10%)  |Positiva (sobreestimació) |
|Bisf             |  4.94  |    1.13    |       337.2       | Sí (+10%)  |Positiva (sobreestimació) |
|ADepreISRS       |  5.15  |    2.83    |       82.0        | Sí (+10%)  |Positiva (sobreestimació) |
|ADepreNoISRS     |  3.13  |    1.46    |       114.4       | Sí (+10%)  |Positiva (sobreestimació) |
|insulina         |  2.08  |    1.18    |       76.3        | Sí (+10%)  |Positiva (sobreestimació) |
|H_SN             |  2.11  |    1.52    |       38.8        | Sí (+10%)  |Positiva (sobreestimació) |
|N_SN             |  4.32  |    2.34    |       84.6        | Sí (+10%)  |Positiva (sobreestimació) |
|H02_SN           |  2.86  |    3.35    |       -14.6       | Sí (+10%)  |Negativa (subestimació)   |
|N06_SN           |  4.16  |    1.95    |       113.3       | Sí (+10%)  |Positiva (sobreestimació) |
|N06A_SN          |  4.58  |    2.09    |       119.1       | Sí (+10%)  |Positiva (sobreestimació) |
|N06AA_SN         |  1.83  |    0.84    |       117.9       | Sí (+10%)  |Positiva (sobreestimació) |
|N06AB_SN         |  4.93  |    2.76    |       78.6        | Sí (+10%)  |Positiva (sobreestimació) |
|N06AX_SN         |  2.98  |    0.96    |       210.4       | Sí (+10%)  |Positiva (sobreestimació) |
|R03BA_SN         |  1.14  |    1.74    |       -34.5       | Sí (+10%)  |Negativa (subestimació)   |



# Discussió

# Avaluació de l'article original des del punt de vista estadístic i metodològic


\clearpage
\appendix

# Annex

## Creuar data

\label{anx:carrega}


``` r
library(haven)
library(dplyr)

uab_demo3 <- read_sas("uab_demo3.sas7bdat", NULL)
uab_drugs3 <- read_sas("uab_drugs3.sas7bdat", NULL)
uab_atcdrugs3 <- read_sas("uab_atc_drugs3.sas7bdat", NULL)

data1 <- merge(uab_demo3, uab_drugs3, by.x="PatNo", by.y="PatNo")
data <- merge(data1, uab_atcdrugs3, by.x="PatNo", by.y="PatNo")

data <- data %>%
  mutate(across(where(~ all(unique(.x) %in% c(0, 1, 2, 3, NA,"M","F"))), as.factor))
data$NFractura=as.factor(data$NFractura)
levels(data$NFractura)[levels(data$NFractura) %in% c("2", "3", "4", "5", "6", "7")]=">=2"
data$ServeiAlta=as.factor(data$ServeiAlta)
data$Edat=cut(data$Edat,breaks=c(50, 65, 81, 95),labels = c("51-65","66-81","82-95"),include.lowest = TRUE)
data=subset(data, select=-c(Hipogonad, FX_familia))
data$Smoker=factor(data$Smoker,levels = c(0,1,2),labels = c("No Fumador", "Fumador Actiu", "Ex-Fumador"))
data$ALCOHOL=factor(data$ALCOHOL,levels = c(0,1,2),labels = c("No consumeix", "Poc consum","Consum moderat"))
data$tipus_diabetis=factor(data$tipus_diabetis,levels = c(0,1,2),labels = c("No diabetis","Tipus 1","Tipus 2"))
```

## Taula característiques

\label{anx:caract}


``` r
library(dplyr)
library(tableone)

variables_demo <- c("Sexe", "Edat" ,"PES", "TALLA", "IMC",
                  "Smoker","ALCOHOL", "Artritis_reumatoide",
                  "Fractura","NFractura","Diabetis","tipus_diabetis","Osteporosi", 
                  "Densitometries","neoplasia","HiperTiroidisme","Malnutricio",
                  "Malabsorcio","Malaltia_Hep_Cro","OthRiskFract", "CountActualGE4")

cat_vars <- c("Sexe", "Smoker", "ALCOHOL", "Artritis_reumatoide","Edat", 
              "Fractura", "Diabetis", "tipus_diabetis", "Osteporosi", "Densitometries",
              "neoplasia", "HiperTiroidisme", "Malnutricio", "Malabsorcio", 
              "Malaltia_Hep_Cro","OthRiskFract", "CountActualGE4")

taula_demo <- CreateTableOne(
  vars = variables_demo,
  strata = "ControlCas.x",
  data = data,
  factorVars = cat_vars,
  includeNA = FALSE
)

tbl<- print(taula_demo)
colnames(tbl)=c("Control","Cas","P_valor"," ")
```

## Anàlisi d'exposició als fàrmacs i els riscs associats de fractura

### Anàlisi descriptiva

\label{anx:descrip}


``` r
variables_farmacs <- c("CortInh",
"CortSist","CortSistIniBf3m","CortSistExpLt3m","CortInhIniBf3m",
"CortInhExpLt3m","ADO_no_glitazona","Bisf","ADepreISRS",
"ADepreNoISRS","insulina","H_SN","N_SN","H01_SN","H02_SN",
"N06_SN","N06A_SN","N06AA_SN","N06AB_SN","N06AX_SN","R03BA_SN")

variables_cat <- variables_farmacs[!grepl("Dias", variables_farmacs)]

taula_des <- CreateTableOne(
  vars = variables_farmacs,
  factorVars = variables_cat,
  strata = "ControlCas.x",
  data = data
)

tbl=print(taula_des)
colnames(tbl)=c("Control","Cas","P_valor"," ")
class(tbl)
```


``` r
library(knitr)
kable(tbl,caption = "\\label{tab:descrip}Comparació de Medicaments i teràpies",align = "lccc")
```

### Anàlisi logística "crua"

``` r
library(survival)

data$cas <- as.numeric(as.character(data$ControlCas.x))
data$strata_id <- as.factor(data$MatchCC.x)

variables_a_excloure <- c("PatNo", "ServeiAlta", "Sexe", "Edat", "MatchCC", "MatchCC.x", "MatchCC.y", "PES", "TALLA", "IMC",
                  "Smoker","ALCOHOL", "Artritis_reumatoide",
                  "Fractura","NFractura","Diabetis","tipus_diabetis","Osteporosi", 
                  "Densitometries","neoplasia","HiperTiroidisme","Malnutricio",
                  "Malabsorcio","Malaltia_Hep_Cro","OthRiskFract", "CountActualGE4", 
  "ControlCas.x", "ControlCas.y", "ControlCas", "cas", "strata_id")

totes_les_columnes <- names(data)

variables_analisi <- setdiff(totes_les_columnes, variables_a_excloure)

resultats_2b <- lapply(variables_analisi, function(variable) {

    formula_model <- as.formula(
    paste("cas ~", variable, "+ strata(strata_id)")
  )
  
  model <- clogit(formula_model, data = data)
  resum <- summary(model)$coefficients
    
    coeficients <- summary(model)$coefficients

    estimacio <- estimacio <- coeficients[1]
    p_valor <- coeficients[5]
    
    OR <- coeficients[2]
    IC_inf <- exp(estimacio-1.96*coeficients[3])
    IC_sup <- exp(estimacio+1.96*coeficients[3])
    
    return(data.frame(
      Variable=variable,
      OR_Cru = round(OR, 2),
      IC_Inferior = round(IC_inf, 2),
      IC_Superior = format(round(IC_sup, 2),nsmall=2),
      P_valor = round(p_valor, 3)
    ))
    })

taula_final_2b <- do.call(rbind, resultats_2b)
rownames(taula_final_2b) <- NULL

tab <- print(taula_final_2b)
```


``` r
kable(tab, caption="\\label{tab:logcru}Anàlisi per regressió logística crua de les variables",align = "lccc")
```

### Anàlisi logística ajustada


``` r
covariables <- c("Osteporosi","Fractura","ALCOHOL","Smoker","Diabetis","CountActualGE4")  

resultats_ajustats <- lapply(variables_analisi, function(variable) {

    formula_model <- as.formula(
        paste("cas ~", variable, "+",paste(covariables, collapse = " + "),"+ strata(strata_id)"
        ))  
    
    model <- clogit(formula_model, data = data)
    coeficients <- summary(model)$coefficients
    
    coeficients <- summary(model)$coefficients
    estimacio <- coeficients[1,1]
    p_valor <- coeficients[1,5]
    OR_aj <- coeficients[1,2]
    IC_inf <- exp(estimacio-1.96*coeficients[1,3])
    IC_sup <- exp(estimacio+1.96*coeficients[1,3])
      
    return(data.frame(
      Variable = variable,
      OR_Ajustat = round(OR_aj, 2),
      IC_Inferior = round(IC_inf, 2),
      IC_Superior = format(round(IC_sup, 2),nsmall=2),
      P_valor = round(p_valor, 3)
    ))
})


taula_final_ajustada <- do.call(rbind, resultats_ajustats)
rownames(taula_final_ajustada) <- NULL
tab2 <- print(taula_final_ajustada)
```


``` r
kable(tab2, caption = "\\label{tab:logajust}Anàlisi per regressió logística ajustada per covariables",align = "lcccc")
```

## Estadístics descriptius, mesures de risc, inferencies...


``` r
#Taula descriptiva
taula_des_df <- data.frame(
  Variable = rownames(tbl),
  Controls = tbl[, "Control"],
  Casos = tbl[, "Cas"],
  stringsAsFactors = FALSE
)

taula_des_df <- taula_des_df %>%
  filter(grepl("= 1 \\(%\\)", Variable))

taula_des_df$Variable <- gsub(" = 1 \\(%\\)", "", taula_des_df$Variable)

#OR crua 
taula_final_2b$Crua <- paste0(
  taula_final_2b$OR_Cru, " (",
  taula_final_2b$IC_Inferior, ",",
  taula_final_2b$IC_Superior, "); p=",
  taula_final_2b$P_valor
)

#OR ajustada
taula_final_ajustada$Ajustada <- paste0(
  taula_final_ajustada$OR_Ajustat, " (",
  taula_final_ajustada$IC_Inferior, ",",
  taula_final_ajustada$IC_Superior, "); p=",
  taula_final_ajustada$P_valor
)

taula_final <- taula_des_df %>%
  left_join(taula_final_2b[, c("Variable", "Crua")], by = "Variable") %>%
  left_join(taula_final_ajustada[, c("Variable", "Ajustada")], by = "Variable")

taula_final <- taula_final %>%
  select(Exposure = Variable,
         `Controls n (%)` = Controls,
         `Casos n (%)` = Casos,
         `OR crua (IC95%); p valor` = Crua,
         `OR ajustada (IC95%); p valor` = Ajustada)

tab3 <- print(taula_final)
```


``` r
kable(taula_final, caption = "Exposició a fàrmacs i riscos associats", align = "lcccc")
```

\clearpage

## Referències
