# Compute regression metrics and plots using `actual_va` and `predicted`.
#
# Copyright (C) 2025, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <2025 Graham Williams>
#
# Author: Graham Williams

# <TIMESTAMP>
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/ for further details.

# Convert actual and predicted to numeric, dropping any NAs.

actual_num    <- as.numeric(actual_va)
predicted_num <- as.numeric(predicted)

valid         <- !is.na(actual_num) & !is.na(predicted_num)
actual_num    <- actual_num[valid]
predicted_num <- predicted_num[valid]

n         <- length(actual_num)
residuals <- actual_num - predicted_num

# Compute standard regression performance metrics.

rmse      <- sqrt(mean(residuals^2))
mae       <- mean(abs(residuals))
ss_res    <- sum(residuals^2)
ss_tot    <- sum((actual_num - mean(actual_num))^2)
r_squared <- ifelse(ss_tot == 0, NA_real_, 1 - ss_res / ss_tot)

## BEGIN RATTLE ONLY

# Write a clearly-delimited summary line that Rattle can scrape from the log.

summary_str <- sprintf(
  "RMSE = %.4f;  MAE = %.4f;  R\u00b2 = %.4f  (n = %d)",
  rmse, mae, r_squared, n
)

writeLines(
  paste0(
    '> ', mtype, '_<DATASET_TYPE>_REGRESSION_SUMMARY: \n',
    summary_str
  )
)

## END RATTLE ONLY

# ── Scatter plot: Actual vs Predicted ────────────────────────────────────────

scatter_title <- glue(
  "Actual vs Predicted &#8212; {mdesc} &#8212; ",
  "{mtype} {basename('<FILENAME>')} ",
  "**{dtype}** ", <TARGET_VAR>
)

svg(
  glue("<TEMPDIR>/evaluate_{mtype}_regression_scatter_{dtype}.svg"),
  width = 11
)

data.frame(actual = actual_num, predicted = predicted_num) %>%
  ggplot(aes(x = actual, y = predicted)) +
  geom_point(alpha = 0.4, colour = "steelblue") +
  geom_abline(intercept = 0, slope = 1, colour = "red", linetype = "dashed") +
  xlab("Actual") +
  ylab("Predicted") +
  ggtitle(scatter_title) +
  annotate(
    "text",
    x     = min(actual_num, na.rm = TRUE),
    y     = max(predicted_num, na.rm = TRUE),
    hjust = 0, vjust = 1, size = 4,
    label = sprintf(
      "RMSE = %.4f\nMAE  = %.4f\nR\u00b2   = %.4f",
      rmse, mae, r_squared
    )
  ) +
  <SETTINGS_GRAPHIC_THEME>() +
  theme(
    plot.title = element_markdown(),
    plot.title.position = "plot"
  )

dev.off()

# ── Residuals vs Fitted plot ─────────────────────────────────────────────────
#
# 20250504 gjw Commented out for now; re-enable when ready.
#
# resid_title <- glue(
#   "Residuals vs Fitted &#8212; {mdesc} &#8212; ",
#   "{mtype} {basename('<FILENAME>')} ",
#   "**{dtype}** ", <TARGET_VAR>
# )
#
# svg(
#   glue("<TEMPDIR>/evaluate_{mtype}_regression_residuals_{dtype}.svg"),
#   width = 11
# )
#
# data.frame(fitted = predicted_num, residuals = residuals) %>%
#   ggplot(aes(x = fitted, y = residuals)) +
#   geom_point(alpha = 0.4, colour = "steelblue") +
#   geom_hline(yintercept = 0, colour = "red", linetype = "dashed") +
#   geom_smooth(method = "loess", se = FALSE, colour = "orange", linewidth = 0.8) +
#   xlab("Fitted Values") +
#   ylab("Residuals") +
#   ggtitle(resid_title) +
#   <SETTINGS_GRAPHIC_THEME>() +
#   theme(
#     plot.title = element_markdown(),
#     plot.title.position = "plot"
#   )
#
# dev.off()
