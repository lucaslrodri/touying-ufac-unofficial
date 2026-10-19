#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(
  lang: "en",
  config-info(
    subject: [Neural Networks],
    title: [Training and evaluation],
    author: [Prof. Author Name],
    subject-code: [PPGEE016],
  ),
)
// --- example ---
== Contents
#outline()

= The perceptron
== One neuron
A weighted sum and a threshold.

= Training
== Gradient descent
Small steps against the gradient.

= Evaluation
== Metrics
Accuracy, precision and recall.
