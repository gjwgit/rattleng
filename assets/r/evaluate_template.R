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

# The `generate_predictions` function simulates a prediction process, generating class labels
# based on randomly created probability matrices for a given set of observations.

generate_predictions <- function(predicted_var) {
  # 1) Handle the case where 'predicted_var' is a named numeric vector.
  #    - If it's numeric and has names, we rename those elements sequentially.
  #    - Then immediately return the vector as-is.

  if (is.numeric(predicted_var) && !is.null(names(predicted_var))) {
    # Rename the elements '1', '2', '3', ... instead of whatever they had before.

    names(predicted_var) <- seq_along(predicted_var)
    return(predicted_var)
  }

  # 2) Handle the case where 'predicted_var' is already a list of matrices
  #    (or at least something indexable like matrices).
  #    - We assume each element in the list has at least 2 columns, and we grab
  #      the value in row 1, column 2 from each element (x[1, 2]).

  if (is.list(predicted_var)) {
    # Extract the second column from row 1 in each element of 'predicted_var'.

    result <- sapply(predicted_var, function(x) x[1, 2])
    # Rename the result elements '1', '2', '3', ...

    names(result) <- seq_along(result)
    return(result)
  }

  # 3) If 'predicted_var' is neither a named numeric vector nor a list:
  #    - We assume it's some other data structure (e.g., a vector of observations).
  #    - We'll generate random probabilities (1×2) for each observation, normalize them,
  #      then extract the second probability for each.

  # Initialize a list to hold the simulated probability matrices.

  predicted_probs <- list()

  # Number of observations is the length of 'predicted_var'.

  num_obs <- length(predicted_var)

  # For each observation, generate random probabilities (2 values),
  # normalize them to sum to 1, then store as a 1×2 matrix.

  for (i in 1:num_obs) {
    probs <- runif(2)          # Generate 2 random probabilities
    probs <- probs / sum(probs)  # Normalize them so they sum to 1
    predicted_probs[[i]] <- matrix(probs, nrow = 1)  # Store as a 1×2 matrix
  }

  # Extract the second probability from each 1×2 matrix (row=1, col=2).

  result <- sapply(predicted_probs, function(x) x[1, 2])

  # Rename the result elements '1', '2', '3', ...

  names(result) <- seq_along(result)

  # Return the vector of probabilities.

  return(result)
}

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
