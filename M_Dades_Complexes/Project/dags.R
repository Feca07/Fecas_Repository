##################################################################################################################################
##################################################################################################################################
#Grafs Bonics
##################################################################################################################################
##################################################################################################################################

library(DiagrammeR)

grViz("
digraph BN {

  graph [layout = dot, rankdir = TB]

  node [shape = box, style = filled, fillcolor = lightblue, fontname = Helvetica]

  quality

  fixed_acidity
  volatile_acidity
  citric_acid
  residual_sugar
  chlorides
  free_sulfur_dioxide
  total_sulfur_dioxide
  density
  pH
  sulphates
  alcohol

  quality -> fixed_acidity
  quality -> residual_sugar
  quality -> chlorides
  quality -> total_sulfur_dioxide
  quality -> free_sulfur_dioxide
  quality -> pH
  quality -> alcohol
  quality -> sulphates
  quality -> citric_acid
  quality -> volatile_acidity
  quality -> density

  residual_sugar -> sulphates
  fixed_acidity -> citric_acid
  residual_sugar -> volatile_acidity
  fixed_acidity -> density
  fixed_acidity -> pH
  alcohol -> chlorides
  density -> total_sulfur_dioxide
  density -> residual_sugar
  total_sulfur_dioxide -> free_sulfur_dioxide
  density -> alcohol
}
")

grViz("
digraph BN {

  graph [
    layout = dot,
    rankdir = TB,
    bgcolor = white
  ]

  node [
    shape = box,
    style = 'rounded,filled',
    fillcolor = '#DCEEFF',
    color = '#2B5D8A',
    fontname = Helvetica,
    fontsize = 11
  ]

  edge [
    color = '#444444',
    arrowsize = 0.7,
    fontname = Helvetica,
    fontsize = 8
  ]

  quality              [label = 'quality', fillcolor = '#FFD966']
  fixed_acidity        [label = 'fixed.acidity']
  volatile_acidity     [label = 'volatile.acidity']
  citric_acid          [label = 'citric.acid']
  residual_sugar       [label = 'residual.sugar']
  chlorides            [label = 'chlorides']
  free_sulfur_dioxide  [label = 'free.sulfur.dioxide']
  total_sulfur_dioxide [label = 'total.sulfur.dioxide']
  density              [label = 'density']
  pH                   [label = 'pH']
  sulphates            [label = 'sulphates']
  alcohol              [label = 'alcohol']

  quality -> fixed_acidity        [label = '1.54e-13']
  quality -> residual_sugar       [label = '6.92e-19']
  quality -> chlorides            [label = '1.92e-21']
  quality -> total_sulfur_dioxide [label = '8.33e-23']
  quality -> free_sulfur_dioxide  [label = '2.77e-34']
  quality -> pH                   [label = '4.98e-35']
  quality -> alcohol              [label = '1.46e-41']
  quality -> sulphates            [label = '1.55e-55']
  quality -> citric_acid          [label = '7.05e-67']
  quality -> volatile_acidity     [label = '7.12e-85']
  quality -> density              [label = '1.60e-123']

  residual_sugar -> sulphates             [label = '1.55e-90']
  fixed_acidity -> citric_acid            [label = '3.80e-92']
  residual_sugar -> volatile_acidity      [label = '3.25e-97']
  fixed_acidity -> density                [label = '1.59e-130']
  fixed_acidity -> pH                     [label = '6.81e-166']
  alcohol -> chlorides                    [label = '9.07e-205']
  density -> total_sulfur_dioxide         [label = '1.52e-267']
  density -> residual_sugar               [label = '0']
  total_sulfur_dioxide -> free_sulfur_dioxide [label = '0']
  density -> alcohol                      [label = '0']
}
")

### NB

grViz("
digraph NaiveBayes {

  graph [
    layout = dot,
    rankdir = TB,
    bgcolor = white,
    ranksep = 3.5,
    nodesep = 0.2
  ]

  node [
    shape = box,
    style = 'rounded,filled',
    fontname = Helvetica,
    fontsize = 11
  ]

  edge [
    color = '#444444',
    arrowsize = 0.7
  ]

  # Nodo raíz
  quality [label = 'quality', fillcolor = '#FFD966', color = '#B8860B']

  pH                   [label = 'pH',                   fillcolor = '#DCEEFF', color = '#2B5D8A']
  fixed_acidity        [label = 'fixed.acidity',        fillcolor = '#DCEEFF', color = '#2B5D8A']
  sulphates            [label = 'sulphates',            fillcolor = '#DCEEFF', color = '#2B5D8A']
  residual_sugar       [label = 'residual.sugar',       fillcolor = '#DCEEFF', color = '#2B5D8A']
  free_sulfur_dioxide  [label = 'free.sulfur.dioxide',  fillcolor = '#DCEEFF', color = '#2B5D8A']
  volatile_acidity     [label = 'volatile.acidity',     fillcolor = '#DCEEFF', color = '#2B5D8A']
  total_sulfur_dioxide [label = 'total.sulfur.dioxide', fillcolor = '#DCEEFF', color = '#2B5D8A']
  citric_acid          [label = 'citric.acid',          fillcolor = '#DCEEFF', color = '#2B5D8A']
  chlorides            [label = 'chlorides',            fillcolor = '#DCEEFF', color = '#2B5D8A']
  density              [label = 'density',              fillcolor = '#DCEEFF', color = '#2B5D8A']
  alcohol              [label = 'alcohol',              fillcolor = '#DCEEFF', color = '#2B5D8A']

  quality -> pH
  quality -> fixed_acidity
  quality -> sulphates
  quality -> residual_sugar
  quality -> free_sulfur_dioxide
  quality -> volatile_acidity
  quality -> total_sulfur_dioxide
  quality -> citric_acid
  quality -> chlorides
  quality -> density
  quality -> alcohol
}
")
