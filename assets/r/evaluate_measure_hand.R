# PLACE HOLDER FOR NOW - THE CODE CAME FROM evaluate_model_rpart.R


# Evaluate the model using HMeasure.

results <- HMeasure(true.class = actual_rpart_labels, scores = predicted_rpart_probs)

svg("TEMPDIR/model_rpart_evaluate_hand.svg")

plotROC(results)

dev.off()
