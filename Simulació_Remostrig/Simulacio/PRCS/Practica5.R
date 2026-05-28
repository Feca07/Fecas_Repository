# 20
library ( simmer )
library ( simmer.plot ) 

env = simmer ( name = "ambulatori" )
print ( env )

env = simmer ( name = "ambulatori" )
pacient = trajectory ( "trajectòria dels pacients" ) %>%
  ## admissió:
  seize   ( "infermer" , 1 ) %>%
  timeout ( function ( ) rnorm ( 1 , mean = 15 , sd = 1 ) ) %>%
  release ( "infermer", 1 ) %>%
  ## consulta mèdica:
  seize   ( "metge" , 1 ) %>%
  timeout ( function ( ) rnorm ( 1 , mean = 20 , sd = 1 ) ) %>%
  release ( "metge" , 1 ) %>%
  ## planificació de futures consultes:
  seize   ( "administratiu" , 1 ) %>%
  timeout ( function ( ) rnorm ( 1 , mean = 5 , sd = 1 ) ) %>%
  release ( "administratiu" , 1 )

env %>%
  add_resource ( "infermer" , 3 ) %>%
  add_resource ( "metge" , 2 ) %>%
  add_resource ( "administratiu" , 1 ) 

env %>%
  add_generator ( "pacient" , pacient , 
                  function ( ) rnorm ( 1 , 10 , 2 ) ) 

plot ( pacient , verbose = TRUE )

# 21
env %>%
  run ( until = 300 )
# És millor i més legible separar els run() de la resta
# tal com diu la vignette "Advanced trajectory usage"

print ( env %>% get_mon_arrivals ( per_resource = FALSE ) ) # default
print ( env %>% get_mon_arrivals ( per_resource = TRUE ) )
print ( env %>% get_mon_arrivals ( per_resource = TRUE , ongoing = TRUE ) )
env %>% get_mon_resources

env %>% get_capacity("infermer") 
env %>% get_queue_size("infermer") 
env %>% get_server_count("infermer") 
env %>% get_queue_count("infermer")
env %>% get_n_generated("pacient")

# 22
arrivals = env %>% get_mon_arrivals ( per_resource = TRUE )
p1=plot ( arrivals , metric = "activity_time" ) 
p2=plot ( arrivals , metric = "waiting_time" ) 
plot ( arrivals , metric = "flow_time" ) 
# Afegir aquí els "waiting time" i "flow-time"

resources = env %>% get_mon_resources
p4=plot ( resources , metric = "usage" )
p6=plot ( resources , metric = "utilization" )#, names="metge")
plot ( resources , metric = "usage" , 
       c ( "infermer" , "metge" ) , 
       items = "server" )
library(patchwork)
p4+p6
p1+p2
env %>% run ( until = 240 )
resources = env %>% get_mon_resources
plot ( resources , metric = "usage" )

# 23
# Temps dels usuaris en el sistema 
# (restant acitvity_time tindriem el delay)
arrivals = env %>% get_mon_arrivals
system_time = arrivals$end_time - arrivals$start_time
summary( system_time )
mean ( system_time )
sd ( system_time )

#Longituds màximes de les cues
resources = env %>% get_mon_resources
res_infermer = resources [ resources$resource == "infermer", ]
long_max_infermer = max ( res_infermer$queue )
res_metge = resources [ resources$resource == "metge" , ]
long_max_metge = max ( res_metge$queue )
res_administratiu = resources [ resources$resource == "administratiu" , ]
long_max_administratiu = max ( res_administratiu$queue )

# 24
# 1.Obtenim el dataframe dels recursos i seleccionem les files del recurs "infermer":
resources = env %>% get_mon_resources 
system_infermer = resources [ resources$resource == "infermer" , ]
# 2.Obtenim les diferències entre els temps en què hi ha esdeveniments, 
# afegint el temps final de la simulació:
time_diffs = diff ( c ( system_infermer$time , now ( env ) ) )
# 3.Obtenim les longituds de les cues:
queue_length = c ( system_infermer$queue )
# 4. Fem la mitjana en el temps:
sum ( queue_length*time_diffs ) / now ( env )

# 25
envs = lapply ( 1 : 100 , function ( i ) 
{ simmer ( name = "ambulatori" ) %>%
    add_resource  ( "infermer" , 1 ) %>%
    add_resource  ( "metge"    , 2 ) %>%
    add_resource  ( "administratiu" , 1 ) %>%
    add_generator ( "pacient" , pacient , function ( ) { 
      rnorm ( 1 , mean = 10 , sd = 2 ) } 
    ) %>%
    run ( until = 240 ) } )

vec_sys_infermer <- numeric ( )
for ( i in 1 : 100 ) {
# 1.Obtenim el dataframe dels recursos i seleccionem les files del recurs "infermer":
resources = envs [[ i ]] %>% get_mon_resources 
system_infermer = resources [ resources$resource == "infermer" , ]
# 2.Obtenim les diferències entre els temps en què hi ha esdeveniments, 
# afegint el temps final de la simulació:
time_diffs = diff ( c ( system_infermer$time , 
                        now ( env ) ) )
# 3.Obtenim les longituds de les cues:
queue_length = c ( system_infermer$queue )
# 4. Fem la mitjana en el temps:
vec_sys_infermer [ i ] = sum ( queue_length*time_diffs ) / now ( env )
}
print ( vec_sys_infermer )
mean  ( vec_sys_infermer )
sd    ( vec_sys_infermer )

# Falta fer els intervals de confiança


