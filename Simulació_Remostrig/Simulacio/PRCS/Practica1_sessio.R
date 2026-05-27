# Simulació. Pràctica 1.

## 2 (a)
arrivals=NULL
set.seed(123)
newArrival = rexp ( n = 1 , rate = 1 / ( 3 / 4 ) )

while ( newArrival <= 60 ) {
  arrivals = c ( arrivals , newArrival )
  interarrivalTime = rexp ( n = 1 , rate = 4 / 3 )
  newArrival = arrivals [ length ( arrivals ) ] + 
    interarrivalTime
}
length ( arrivals )

y = seq  ( from = 0 , 
           to = length ( arrivals ) , 
           by = 1 )
plot ( stepfun ( arrivals , 
                 y , 
                 f = 0 , 
                 right = FALSE ) , 
       xlim = c ( 0 , 60 ) )

exits  = numeric ( length ( arrivals ) )
delays = numeric ( length ( arrivals ) )
delays [ 1 ] = 0
serviceTime  = 36/60
exits [ 1 ] = arrivals [ 1 ] + 
  delays [ 1 ] + 
  serviceTime
i = 1
while (i < length ( arrivals ) ) {
  i = i + 1
  if ( arrivals [ i ] >= exits [ i - 1 ] ) {
    delays [ i ] = 0
    } else {
      delays [ i ] = exits [ i - 1 ] - arrivals [ i ]
  }
  serviceTime = 36/60
  exits [ i ] = arrivals [ i ] + delays [ i ] + serviceTime
}

arrivals ; exits ; delays
mean ( delays )

## 2 (b,c)
queue = function (  ) {
  arrivals = numeric ( 0 )
  newArrival = rexp ( n = 1, rate = 4 / 3 )
  while ( newArrival <= 60 ) {
    arrivals = c ( arrivals , newArrival )
    interarrivalTime = rexp ( n = 1, rate = 4 / 3 )
    newArrival = arrivals [ length ( arrivals ) ] + interarrivalTime
  }

  exits  = numeric ( length ( arrivals ) )
  delays = numeric ( length ( arrivals ) )
  delays [ 1 ] = 0
  serviceTime = 0.6
  exits [ 1 ] = arrivals [ 1 ] + delays [ 1 ] + serviceTime

  i = 1
  while ( i < length ( arrivals ) ) {
    i = i + 1
    if ( arrivals [ i ] >= exits [ i - 1 ] ) {
      delays [ i ] = 0
    } else {
      delays [ i ] = exits [ i - 1 ] - arrivals [ i ]
    }
    serviceTime = 0.6
    exits [ i ] = arrivals [ i ] + delays [ i ] + serviceTime
  }

  return ( c ( mean ( delays ) , 
               max  ( delays ) , 
               exits [ length ( exits ) ] ) )
}

returned_list = replicate ( 1000000 , queue ( ) )
mean_delays   = returned_list [ 1 , ]
max_delays    = returned_list [ 2 , ]
last_exits    = returned_list [ 3 , ]
hist(mean_delays)
mean ( mean_delays )
mean ( max_delays  )
mean ( last_exits  )

## 2 (d)
queue = function (  ) {
  arrivals = numeric ( 0 )
  newArrival = rexp ( n = 1, rate = 4 / 3 )
  while ( newArrival <= 60 ) {
    arrivals = c ( arrivals , newArrival )
    interarrivalTime = rexp ( n = 1, rate = 4 / 3 )
    newArrival = arrivals [ length ( arrivals ) ] + interarrivalTime
  }
  
  exits  = numeric ( length ( arrivals ) )
  delays = numeric ( length ( arrivals ) )
  delays [ 1 ] = 0
  serviceTime = rexp ( n = 1, rate = 1 / ( 36 / 60 ) )
  exits [ 1 ] = arrivals [ 1 ] + delays [ 1 ] + serviceTime
  
  i = 1
  while ( i < length ( arrivals ) ) {
    i = i + 1
    if ( arrivals [ i ] >= exits [ i - 1 ] ) {
      delays [ i ] = 0
    } else {
      delays [ i ] = exits [ i - 1 ] - arrivals [ i ]
    }
    serviceTime = rexp ( n = 1, rate = 1 / ( 36 / 60 ) )
    exits [ i ] = arrivals [ i ] + delays [ i ] + serviceTime
  }
  
  return ( c ( mean ( delays ) , 
               max  ( delays ) , 
               exits [ length ( exits ) ] ) )
}

returned_list = replicate ( 1000 , queue ( ) )
mean_delays   = returned_list [ 1 , ]
max_delays    = returned_list [ 2 , ]
last_exits    = returned_list [ 3 , ]

mean ( mean_delays )
mean ( max_delays  )
mean ( last_exits  )

## 3
queue = function ( ) {
  arrivals = sort ( runif ( n = 80 , min = 0 , max = 60 ) )
  exits  = numeric ( length ( arrivals ) )
  delays = numeric ( length ( arrivals ) )
  delays [ 1 ] = 0
  serviceTime = rexp ( n = 1 , rate = 1 / 0.6 )
  exits [ 1 ] = arrivals [ 1 ] + delays [ 1 ] + serviceTime
  i = 1
  while (i < length ( arrivals ) ) {
    i = i + 1
    if ( arrivals [ i ] >= exits [ i - 1 ] ) {
      delays [ i ] = 0
    } else {
      delays [ i ] = exits [ i - 1 ] - arrivals [ i ]
    }
    serviceTime = rexp ( n = 1 , rate = 1 / 0.6 )
    exits [ i ] = arrivals [ i ] + delays [ i ] + serviceTime
  }

  return ( c ( mean ( delays ) , 
               max  ( delays ) , 
               exits [ length ( exits ) ] ) )
}

returned_list = replicate ( 1000 , queue ( ) )
mean_delays   = returned_list [ 1 , ]
max_delays    = returned_list [ 2 , ]
last_exits    = returned_list [ 3 , ]

mean ( mean_delays )
mean ( max_delays  )
mean ( last_exits  )

