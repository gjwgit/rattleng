# Rattle Scripts: From dataset ds build a linear model.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Monday 2024-10-07 17:03:05 +1100 Graham Williams>
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
# Author: Zheyuan Xu

library(rattle)

# Define model type and description.

mtype <- "linear"
mdesc <- "Linear Model"

# Define the formula for the model.

form <- as.formula(paste(target, "~ ."))

# Build a Logistic Regression Model.

model_glm <- glm(
  form,
  data   = ds[tr, vars],
  family = binomial(link = LINEAR_FAMILY),
)

# Generate a textual view of the Logistic Regression Model.

print(summary(model_glm))

# Display additional model statistics.

cat(sprintf("Log likelihood: %.3f (%d df)\n",
            logLik(model_glm)[1],
            attr(logLik(model_glm), "df")))

cat(sprintf("Null/Residual deviance difference: %.3f (%d df)\n",
            model_glm$null.deviance - model_glm$deviance,
            model_glm$df.null - model_glm$df.residual))

cat(sprintf("Pseudo R-Square (optimistic): %.8f\n",
             cor(model_glm$y, model_glm$fitted.values)))

cat('\n==== ANOVA ====\n\n')
print(anova(model_glm, test = "Chisq"))
cat("\n")

# Plot diagnostic plots for the logistic regression model.

svg("TEMPDIR/model_glm_diagnostic_plots.svg")
par(mfrow = c(2, 2))
plot(model_glm)
dev.off()

# Prepare probabilities for predictions.

predicted <- predict(model_glm, 
                     newdata = tuds, 
                     type    = "response")

# Get unique levels of predicted.

levels_predicted <- unique(predicted)
levels_actual <- unique(actual)

# Convert `predicted` to numeric, handling NA values.

predicted_numeric <- suppressWarnings(as.numeric(predicted))

# Generate risk chart.

svg("TEMPDIR/model_glm_risk.svg")
rattle::riskchart(predicted_numeric, actual_numeric, risks) +
  labs(title="Risk Chart - Tuning Dataset") +
  theme(plot.title = element_text(size=14))
dev.off()
