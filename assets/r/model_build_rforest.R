# From dataset `trds` build a `randomForest()` forest model.
#
# Copyright (C) 2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Tuesday 2025-05-13 16:43:32 +1000 Graham Williams>
#
# Licensed under the GNU General Public License, Version 3 (the "License");
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author: Graham Williams

# Random Forest using randomForest()
#
# <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials Chapter 8.
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(kernlab)
library(randomForest) # ML: randomForest() na.roughfix() for missing data.
library(reshape2)
library(verification)

mtype <- "randomForest"
mdesc <- "Random Forest"

# Train a random forest model based on the training dataset.

model_randomForest <- randomForest(
  form,
  data       = trds,
  ntree      = <RF_NUM_TREES>,
  mtry       = <RF_MTRY>,
  importance = TRUE,
  na.action  = <RF_NA_ACTION>,
  replace    = FALSE <RF_INPUT_SAMPSIZE>)

########################################################################

# Generate textual output of the 'Random Forest' model.

print(model_randomForest)

# The `pROC' package implements various AUC functions.

# Calculate the Area Under the Curve (AUC).

print(pROC::roc(model_randomForest$y,
                as.numeric(model_randomForest$predicted)))

# Calculate the AUC Confidence Interval.

print(pROC::ci.auc(model_randomForest$y, as.numeric(model_randomForest$predicted)))

# List the importance of the variables.

rn <- round(randomForest::importance(model_randomForest), 2)
rn[order(rn[,3], decreasing=TRUE),]

# Display tree number 1.

printRandomForest(model_randomForest, <RF_NO_TREE>, max.rules = <RF_MAX_SHOW_RULES>)

# Plot the relative importance of the variables.

# Assuming `model_randomForest` is already trained.
# Extract variable importance for each class.

importance_matrix <- importance(model_randomForest)

# Convert to a data frame for easy plotting.

importance_df <- as.data.frame(importance_matrix)
importance_df$Variable <- rownames(importance_df)

# Melt the data frame to long format for ggplot.

importance_long <- melt(importance_df,
                        id.vars       = "Variable",
                        variable.name = "Class",
                        value.name    = "Importance")

svg("<TEMPDIR>/model_random_forest_varimp.svg", height=6, width=10)
ggplot(importance_long, aes(x    = reorder(Variable, Importance),
                            y    = Importance,
                            fill = Class)) +
  geom_bar(stat     = "identity",
           position = "dodge") +
  coord_flip() +
  labs(
    title = "Variable Importance for Different Target Classes",
    x     = "Variable",
    y     = "Importance"
  )  +
  <SETTINGS_GRAPHIC_THEME>()
dev.off()

########################################################################

# Plot the error rate against the number of trees.

# WITH THIS CODE WE SEEM TO RUN OUT OF BUFFER TO SEND TO R

errors <- model_randomForest$err.rate

svg("<TEMPDIR>/model_random_forest_error_rate.svg", height=5, width=9)
errors %>%
  as.data.frame() %>%
  dplyr::mutate(Index=1:nrow(.)) %>%
  tidyr::pivot_longer(cols = colnames(errors),
                      names_to = "Category",
                      values_to = "Value") %>%
  dplyr::mutate(Category = factor(Category,
                                  levels = colnames(errors))) %>%
  ggplot(aes(x = Index, y = Value, color = Category)) +
  geom_line() +
  labs(title = "Error Rates as Trees Added to Random Forest",
       x = "Trees",
       y = "Error",
       color = "Category") +
  <SETTINGS_GRAPHIC_THEME>()
dev.off()

# Plot the OOB ROC curve.

svg("<TEMPDIR>/model_random_forest_oob_roc_curve.svg", height=7, width=10)

# Extract observed class labels from the Random Forest model.

observed <- model_randomForest$y  # This is a factor

# Get the class labels from the model.

class_labels <- levels(observed)

# Check the distribution of classes.

class_counts <- table(observed)

# Decide on the positive class.
# Let's choose the class with fewer observations as the positive class.

positive_class <- names(which.min(class_counts))

# Convert observed outcomes to binary (0/1).

observed_binary <- ifelse(observed == positive_class, 1, 0)

# Extract the OOB predicted probabilities for the positive class.

predicted_probs <- model_randomForest$votes[, positive_class]

# Remove any NA values.

valid_indices <- !is.na(predicted_probs) & !is.na(observed_binary)
predicted_probs <- predicted_probs[valid_indices]
observed_binary <- observed_binary[valid_indices]

# Check if we have enough data points in each class.

min_class_size <- min(sum(observed_binary == 1), sum(observed_binary == 0))

if (min_class_size >= 3 && length(unique(predicted_probs)) > 1) {
  # Calculate ROC curve using pROC package instead of verification.

  roc_obj <- pROC::roc(observed_binary, predicted_probs,
                       quiet     = TRUE,
                       ci        = TRUE,
                       ci.method = "delong")

  roc_obj <- pROC::roc(observed_binary, predicted_probs)

  roc_df <- data.frame(
    TPR = roc_obj$sensitivities,
    FPR = 1 - roc_obj$specificities
  )

  # Calculate AUC and 95% CI

  auc_value <- pROC::auc(roc_obj)
  ci <- pROC::ci.auc(roc_obj)

  roc_df %>%
    ggplot(aes(x=FPR, y=TPR)) +
    geom_line(color="blue") +
    geom_abline(slope     = 1,
                intercept = 0,
                linetype  = "dashed",
                color     = "red") +
    labs(title = "OOB ROC Curve Random Forest",
         x     = "False Positive Rate (1 - Specificity)",
         y     = "True Positive Rate (Sensitivity)") +
    annotate("text", x=0.8, y=0.1,
             label=sprintf("AUC: %.3f\n95%% CI: %.3f-%.3f",
                             auc_value, ci[1], ci[3]),
             size=5, hjust=0) +
  <SETTINGS_GRAPHIC_THEME>()

} else {
  # Create an empty plot with an error message.

  plot(0, 0,
       type = "n",
       main = "ROC Curve Error",
       xlab = "",
       ylab = "",
       axes = FALSE)
  text(0, 0,
       paste("Insufficient data for ROC curve:\n",
             "Minimum class size =", min_class_size,
             "\nUnique probability values =",
             length(unique(predicted_probs))),
       cex = 1.2)
}
dev.off()

########################################################################

# Generate details about the different tree sizes in the forest.

# A support function to count leaf nodes in a tree.

count_leaf_nodes <- function(tree) {
  tree_struct <- getTree(model_randomForest, k=tree, labelVar=FALSE)
  leaf_count <- sum(tree_struct[, "status"] == -1)
  return(leaf_count)
}

# Get the number of trees in our model.

num_trees <- model_randomForest$ntree

# Create a data frame with tree number and leaf count.

rf_tree_info <- data.frame(
  tree_number = 1:num_trees,
  leaf_nodes = sapply(1:num_trees, count_leaf_nodes)
)

# View the results.

print(rf_tree_info)

# Summary statistics of leaf nodes across trees.

summary(rf_tree_info$leaf_nodes)

# Plot the distribution of leaf nodes.

svg("<TEMPDIR>/model_random_forest_leaf_node_distribution.svg", height=5, width=10)
rf_tree_info %>%
  ggplot2::ggplot(aes(x=leaf_nodes)) +
  ggplot2::geom_histogram(binwidth = 1,
                          fill     = "steelblue",
                          color    = "white",
                          alpha    = 0.7) +
  ggplot2::geom_density(aes(y = after_stat(count)),
                        color = "darkred",
                        linewidth = 1) +
  ggplot2::labs(
    title    = "Distribution of Tree Sizes in the Random Forest",
    subtitle = paste("Based on", num_trees, "trees"),
    x        = "Number of Leaf Nodes (Rules)",
    y        = "Count"
  ) +
  <SETTINGS_GRAPHIC_THEME>() +
  theme(
    plot.title = element_text(face="bold"),
    axis.title = element_text(face="bold")
  )
dev.off()
