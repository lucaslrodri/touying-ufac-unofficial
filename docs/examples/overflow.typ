#import "@preview/touying:0.7.4": *
#import "../../src/lib.typ": *
#show: ufac-theme.with(lang: "en", config-info(
  title: [Training and evaluation], subtitle: [Units III and IV], author: [Prof. Author Name],
  subject: [Neural Networks], subject-code: [PPGEE016],
))
// --- example ---
== Training loop

=== Steps of one epoch

+ Shuffle the training set
+ Split it into batches
+ Forward pass on the batch
+ Compute the loss
+ Backward pass
+ Update the weights
+ Repeat for every batch
+ Evaluate on the validation set
+ Save the best weights
+ Check the stopping rule
+ Decay the learning rate
+ Log the metrics
+ Plot the learning curves
+ Compare with the baseline
+ Start the next epoch
