
####################################
## CONSIDER MOVING THESE FUNCTION DEFINITIONS TO SESSION START AND THEN INTO THE Rattle PACKAGE
####################################

# 20250121 gjw These migrated from model_template.R as not required
# for model build but probaly for evaluate? Needs to confirm.

# TODO 20241202 gjw <REVIEW> ALL OF THE <FOLLOWING> - WHY HERE OR WHY <NEEDED>

# Identify predictor variables (excluding the target variable).

# TODO 20241202 gjw WHY IS THIS <NEEDED> - USE <INPUTS>

# predictor_vars <- setdiff(vars, target)

# Identify categoric and numeric input variables.

# 20250121 gjw FIX THIS - SHOULD USE numc and catc?

# NOT ACTUALLY USED SO REMOVE THEM

# cat_vars <- names(Filter(function(col) is.factor(col) || is.character(col), ds[inputs]))
# num_vars <- setdiff(inputs, cat_vars)

# TODO 20241112 gjw FIX THIS <CLUMSY> NAME

# ignore_categoric_vars <- c(num_vars, target)

# TODO 20241202 gjw THIS <SEEMS> OUT OF <PLACE> HERE

# neural_ignore_categoric <- <NEURAL_IGNORE_CATEGORIC>

# Create numeric risks vector.

# TODO 20241202 gjw WHAT IS THIS USED FOR? CAN NOW BE <REMOVED>?

risks <- as.character(risk_tu)
risks <- risks[!is.na(risks)]
risks <- as.numeric(risks)

# Create numeric actual vector.

# TODO 20241202 gjw WHAT IS THIS USED FOR? CAN NOW BE <REMOVED>?

actual <- as.character(actual_tu)
actual <- actual[!is.na(actual)]
levels_actual <- unique(actual)
actual_numeric <- ifelse(actual == levels_actual[1], 0, 1)


# A data preprocessing function for prediction tasks.
# Handles prediction and actual value preprocessing.
# Converts inputs to numeric format. Handles NA and NaN values.
# Aligns input vectors to same length. Uses minimum length to truncate vectors.

prepare_predictions <- function(pr_tu, actual, risks) {
  # Get unique levels of predictions and actual values.

  levels_predicted <- unique(pr_tu)

  # Convert predictions to numeric, handling NA or invalid values.

  predicted_numeric <- ifelse(pr_tu == levels_predicted[1], 0, 1)
  predicted_numeric <- suppressWarnings(as.numeric(pr_tu))
  predicted_numeric <- ifelse(is.na(predicted_numeric) | is.nan(predicted_numeric), 0, predicted_numeric)

  # Align vectors to the same length by using the minimum length.

  min_length <- min(length(predicted_numeric), length(actual), length(risks))
  predicted_numeric <- predicted_numeric[1:min_length]
  actual_numeric <- as.numeric(as.factor(actual))[1:min_length] - 1
  actual_numeric <- ifelse(actual_numeric < 0, 0, actual_numeric) # Ensure no negative values.
  risks <- risks[1:min_length]

  # Replace remaining NA or NaN values in `predicted_numeric` with a default value.

  predicted_numeric <- ifelse(is.na(predicted_numeric) | is.nan(predicted_numeric), 0, predicted_numeric)

  # Replace NA or NaN in actual_numeric with a default value (e.g., 0).

  actual_numeric <- ifelse(is.na(actual_numeric) | is.nan(actual_numeric), 0, actual_numeric)

  # Return the processed vectors as a list.

  list(
    predicted_numeric = predicted_numeric,
    actual_numeric = actual_numeric,
    risks = risks
  )
}
