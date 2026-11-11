/// Synopsis: the packages Touying integrates: a CeTZ canvas and a Fletcher diagram that reveal their parts with `#pause` through `touying-reduce`, on a slide and inside the box of a question, where the covered parts are hidden as Touying does (the diagrams keep their size). It imports CeTZ and Fletcher, so it is not part of the catalogue.
#import "../../common.typ": *
#import "@preview/cetz:0.5.2"
#import "@preview/fletcher:0.5.8" as fletcher: node, edge
#show: setup

#let cetz-canvas = touying-reduce.with(cetz)
#let fletcher-diagram = touying-reduce.with(fletcher)

== CeTZ, step by step
#cetz-canvas({
  import cetz.draw: *
  rect((0, 0), (4, 2.5), stroke: colors.primary)
  (pause,)
  circle((2, 1.25), radius: 1, stroke: colors.tertiary)
  (pause,)
  line((0, 0), (4, 2.5), stroke: colors.quaternary)
})

== Fletcher in a question <question>
Follow the states of a file:

#fletcher-diagram(
  node-stroke: .08em,
  spacing: 3em,
  node((0, 0), [open]),
  pause,
  edge("-|>"),
  node((1, 0), [read]),
  pause,
  edge("-|>"),
  node((2, 0), [closed]),
)
