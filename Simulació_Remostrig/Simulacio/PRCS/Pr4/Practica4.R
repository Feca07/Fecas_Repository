##15
# Proves amb la FEL
## Creem un dataframe buit.
time  = numeric ( )
event = character ( )
FEL   = data.frame ( time , event )
ncol ( FEL ) # dona 2
nrow ( FEL ) # dona 0

## Afegir files:
newNotice = data.frame ( time  = 1.50 ,
                         event = "arribada" )
FEL = rbind ( FEL , 
              newNotice ) 
ncol ( FEL ) # dona 2
nrow ( FEL ) # dona 1
newNotice = data.frame ( time  = 2.15 , 
                         event = "sortida" )
FEL = rbind ( FEL , 
              newNotice ) 
ncol ( FEL ) # dona 2
nrow ( FEL ) # dona 2

## Ordenar cronològicament els event notice del dataframe 
FEL = FEL [ order ( FEL$time ) , ]

## Eliminar el primer event notice del dataframe
FEL = FEL [ -1 , ]

##16-17
# Creació d'una Future Event List (FEL) buida:
time  = numeric ( )
event = character ( )
FEL   = data.frame ( time , 
                     event )

# Inicialització de les variables estadístiques:
# vector amb els instants d'arribada de cada usuari:
# arrivalTime   = numeric ( ) 
# vector amb el delay (temps en cua) de cada usuari: 
# delayInQueue  = numeric() 
# vector amb el temps de cada usuari en el servei:
# timeInService = numeric() 
# vector amb els instants de soritda del sistema de cada usuari:
# departureTime = numeric() 
# quantitat de usuaris que han hagut d'esperar en cua
customersDelayed = 0 
# quantitat d'usuaris en cua (varia amb el temps)
customersInQueue    = 0 
# ocupació del servei (0 o 1) (varia amb el temps)
occupationOfService = 0 
# Inicialització del rellotge
clock = 0  

# Temps final de simulació
finalTime = 20 # 60 minuts

# Generació d'una arribada
generateArrival = function ( ) { 
  nextArrival = clock + rexp ( rate = 60/45 , n = 1 )
  if ( nextArrival <= finalTime ) {
    newEvent = data.frame ( time  = nextArrival , 
                            event = "arribada" )
    FEL <<- rbind ( FEL, newEvent ) 
    FEL <<- FEL [ order ( FEL$time ) , ] 
  }
}

beginService = function ( ) { 
  occupationOfService <<- 1
  nextCompletion = clock + rexp ( rate = 60/36 , n = 1 )
  newEvent = data.frame ( time  = nextCompletion , 
                          event = "sortida" )
  FEL <<- rbind ( FEL , newEvent ) 
  FEL <<- FEL [ order ( FEL$time ) , ]
}

arrival = function ( ) { 
  if( occupationOfService == 0 ) {
    beginService ( )
  }
  else { 
    customersInQueue <<- customersInQueue + 1
  }
  generateArrival ( ) 
}

exit = function ( ) { 
  if( customersInQueue > 0 ) {
    customersInQueue <<- customersInQueue - 1
    beginService ( )
  }
  else { 
    occupationOfService <<- 0
  }
}

# Inicialització de la simulació. Cal crear un esdeveniment i posar-lo a la FEL.
# Només pot ser l'arribada d'un primer usuari:
print ( "FEL_inicial" )
print ( FEL )
generateArrival ( ) 
# Entrada al bucle principal de la simulació. Mentre hi hagi esdeveniments
# a la FEL, seguim processant:
set.seed ( 123 )
while ( nrow ( FEL ) > 0) {
  print ( "-----" ) 
  print ( "in main loop:" )
  print ( customersInQueue )
  print ( FEL )
  clock <<- FEL [ 1 , 1 ] 
  if ( FEL [ 1 , 2 ] == "arribada") {
    FEL <<- FEL [ -1 , ]
    arrival ( )
  }
  else { 
    FEL <<- FEL [ -1 , ]
    exit ( )
  }
}

# Amb la set.seed podem fer una definició del procés:
# (1) Primera arribada t=0.6342915. 
# (2) Es genera una arribada i una sortida. La primera persona que 
# ha arribat sortirà més tard que la segona arribada ja que
# la primera persona sortirà a 1.140366 i la segona
# arribada és a t=1.066749. En el punt t=0.6342915 no hi ha ningú
# a la cua. 
# (3) Es genera una nova arribada i la sortida de l'individu que ha 
# arribat a t=1.066749. La nova arribada és a t=1.090432 i la sortida
# de l'individu que arriba a t=1.066749 és a t=1.864182.

# install.packages ( "simmer" )
# install.packages ( "simmer.plot" )
library ( simmer )
library ( simmer.plot )

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

envs = lapply ( 1 : 100 , function ( i ) 
  { simmer ( name = "ambulatori" ) %>%
    add_resource  ( "infermer" , 1 ) %>%
    add_resource  ( "metge"    , 2 ) %>%
    add_resource  ( "administratiu" , 1 ) %>%
    add_generator ( "pacient" , pacient , function ( ) { 
      rnorm ( 1 , mean = 10 , sd = 2 ) } 
      ) %>%
    run ( until = 60 ) } )

print ( envs )

# pacients generats en la rèplica 9
print ( envs [[ 1 ]] %>% get_n_generated ( "pacient" ) )
# per a totes les rèpliques 
sapply ( envs , function ( i ) i %>% get_n_generated ( "pacient" ) )
# Mida de la cua esperant infermer en el
# moment que hem aturat la simulació (minut 60)
# per a totes les rèpliques 
sapply ( envs , function ( i ) i %>% get_queue_count ( "infermer" ) )
# # mida màxima permesa de la cua esperant metge per a totes les 
# rèpliques 
sapply ( envs , function ( i ) i %>% get_queue_size ( "metge" ) )

plot ( pacient , verbose = TRUE )
