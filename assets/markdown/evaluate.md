# Model Performance Evaluation

The **Evaluate** tab in Rattle is essential for assessing the
performance and accuracy of machine learning models. This tab provides
various evaluation metrics and visualizations to help you understand
how well your model is performing on the selected dataset.

- **Error Matrix**: An error matrix or confusion matrix will show the
  count or proportion of correct and incorrect predictions.  The error
  matrix helps in understanding model performance on each class.

- **ROC (Receiver Operating Characteristic)**: An ROC curve
  pictorially displays the true positive rate against the false
  positive rate, providing insight into the model’s ability to
  differentiate between classes.

- **Risk Chart**: When you have a risk variable then a risk chart is
  often useful. The risk is a measure of the size of the risk when a
  positive prediction is made (e.g., the amount of rain tomorrow if we
  predict that it will rain, or the dollar return if we predict a
  financial audit will be productive).

- **Precision, Sensitivity, and Other Metrics**: A variety of other
  metrics are provided to support a comprehensive understanding of
  your model's classification power.

Our models are built using the **training dataset**. When we evaluate
the model on the training dataset we expect the model to perform quite
well. This is a biased estimate of the final performance of the
model. The **tuning dataset (also known as the **validation dataset**)
is used to provide an unbiased estimate of the performance of a model
so that we can tune the model parameters, build a new model and test
the model again. The **testing dataset** is then used once we are
happy with our tuned model, and provides the final unbiased estimate
of the final model's performance.
