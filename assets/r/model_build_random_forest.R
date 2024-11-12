# Rattle Scripts: From dataset ds build a random forest model.
#
# Copyright (C) 2023, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-09-07 15:38:57 +1000 Graham Williams>
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
# TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 8.
# https://survivor.togaware.com/datascience/ for further details.

# Load required packages from the local library into the R session.

library(rattle)
library(randomForest) # ML: randomForest() na.roughfix() for missing data.
library(ggplot2)
library(reshape2)
library(verification)

mtype <- "randomForest"
mdesc <- "Forest"

# Typically we use na.roughfix() for na.action.

tds <- ds[tr, vars]

model_randomForest <- randomForest(
  form,
  data       = tds, 
  ntree      = RF_NUM_TREES,
  mtry       = RF_MTRY,
  importance = TRUE,
  na.action  = RF_NA_ACTION,
  replace    = FALSE)

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

printRandomForests(model_randomForest, RF_NO_TREE)

# Plot the relative importance of the variables.

svg("TEMPDIR/model_random_forest_varimp.svg")

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
  ) +
  theme_minimal()

dev.off()


# Plot the error rate against the number of trees.

svg("TEMPDIR/model_random_forest_error_rate.svg")

plot(model_randomForest, main="")
legend("topright", c("OOB", "No", "Yes"), 
       text.col = 1:6, 
       lty      = 1:3, 
       col      = 1:3)
title(main="Error Rates Random",
    sub=paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), Sys.info()["user"]))

dev.off()

# Plot the OOB ROC curve.

svg("TEMPDIR/model_random_forest_oob_roc_curve.svg")

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
  
  # Plot ROC curve.

  plot(roc_obj, 
       main        = "OOB ROC Curve Random Forest",
       col         = "blue", 
       lwd         = 2,
       legacy.axes = TRUE)
  
  # Add diagonal reference line.

  abline(0, 1, lty = 2, col = "gray")
  
  # Add AUC to the plot.

  auc_value <- pROC::auc(roc_obj)
  legend("bottomright", 
         legend = sprintf("AUC = %.3f\n95%% CI: %.3f-%.3f", 
                         auc_value,
                         roc_obj$ci[1],
                         roc_obj$ci[3]),
         bty = "n")
  
  # Add subtitle.

  mtext(paste("Rattle", format(Sys.time(), "%Y-%b-%d %H:%M:%S"), 
              Sys.info()["user"]), 
        side = 3, 
        line = 0.5, 
        cex  = 0.8)
  
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
