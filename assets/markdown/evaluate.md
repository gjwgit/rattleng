# Rattle - Evaluate Tab

The **Evaluate** tab in Rattle is essential for assessing the
performance and accuracy of machine learning models. This tab
provides various evaluation metrics and visualization options
to help you understand how well your model is performing on the
selected dataset. Below are key components and functions within
the **Evaluate** tab:

### 1. **Evaluation Type Selection**

   - **Error Matrix**: This provides a confusion matrix, showing
   the counts or proportions of correct and incorrect predictions.
   The error matrix helps in understanding model performance on
   each class.
   - **ROC (Receiver Operating Characteristic)**: Allows you to
   view the ROC curve, which plots the true positive rate against
   the false positive rate, providing insight into the model’s ability
   to differentiate between classes.
   - **Precision, Sensitivity, and Other Metrics**: You can select
   different metrics to gain a comprehensive understanding of your
   model's classification power.

### 2. **Model Selection**

   - Choose from different models you’ve built, such as Decision
   Trees, Neural Networks, SVM, etc. This selection lets you compare
   various models and identify which performs best on the validation
   or test data.

### 3. **Data Selection**

   - **Training, Validation, Testing, or Full Dataset**: Select the
   dataset to use for evaluation. Typically, the **Validation** or
   **Testing** set is used to measure model performance, as this data
   was not involved in training.

### 4. **Result Options**

   - **Class or Probability**: You can choose to evaluate the model
   based on class predictions (labels) or probability scores,
   depending on the type of analysis needed.
   - **Error Output**: The error matrix provides both count and
   proportion-based matrices, showing you the error rate in actual
   numbers and percentages for better clarity.

### 5. **Error and Accuracy Metrics**

   - **Overall Error**: The total error rate across all predictions.
   - **Averaged Class Error**: The average error rate per class,
   useful for assessing model balance.

   These metrics help gauge overall model performance and identify
   if any class is underperforming or biased.

### 6. **Report Generation**

   - You can generate a detailed report summarizing the evaluation
   results, useful for documentation or presentations.

---

The **Evaluate** tab is a powerful tool within Rattle for model
assessment, allowing you to iteratively improve your models based
on insightful metrics.