# Neural Network Model

The concept of a neural network in artificial intelligence has been
circulating since the very beginning of the discussions of artificial
intelligence. The neural network model is based on our understanding
of the structure of our own brains, with neurons connected to many
other neurons in a complex network.

Our conceptualisation of the neural network model is based on the idea
of multiple layers of neurons connected to neurons in other layers,
feeding numeric data through the network, combining the numbers,
to produce a final answer.

The advent of large language models and generative models has neural
networks at their foundation.

Rattle supports single layer and multiple layer networks, with the
first layer being our input data and the final layer being the out,
the prediction, and generating what comes next. Feed forward and back
propagation are basic concepts for training our networks to reflect
the provided training datasets.

Within Rattle you have a choice of using the **nnet** function for a
single layer network or the **neuralnet** function for a multi layer
network. Make your choice, specify the layers and other parameters,
and then **build** the network. The resulting pages will provide a
textual summary and a visual summary of the networks, and a measure of
their performance on the tuning dataset.
