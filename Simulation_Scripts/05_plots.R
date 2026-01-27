library(ggplot2); library(cowplot)

# load
#performance_summary <- readRDS("Simulation_Scripts/performance_summary.rds")

# panel A: absolute bias plot (not used in final figure)
# shows raw difference between estimated and true ACE
p_bias <- ggplot(
  performance_summary,
  aes(x = n, y = bias, color = confound_label, group = confound_label)
) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  geom_point(size = 3) +
  geom_line() +
  labs(
    x = "Sample size (n)",
    y = "Absolute Bias",
    color = "Confounding\nnon-linearity",
    title = "Absolute Bias from Omitting X²"
  ) +
  theme_minimal() +
  theme(legend.position = "right")

# panel A (final): relative bias plot
# ratio of estimated to true ACE (1 = unbiased)
p_rel_bias <- ggplot(
  performance_summary,
  aes(x = n, y = rel_bias, color = confound_label, group = confound_label)
) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "gray50") +
  geom_point(size = 3) +
  geom_line() +
  labs(
    x = "Sample size (n)",
    y = "Relative Bias",
    color = "Confounding\nnon-linearity",
    title = "Relative Bias from Omitting X²"
  ) +
  theme_minimal() +
  theme(legend.position = "right")

# absolute RMSE plot (not used in final figure)
# raw root mean squared error
p_rmse <- ggplot(
  performance_summary,
  aes(x = n, y = rmse, color = confound_label, group = confound_label)
) +
  geom_point(size = 3) +
  geom_line() +
  labs(
    x = "Sample size (n)",
    y = "RMSE of ACE estimator",
    color = "Confounding\nnon-linearity",
    title = "Absolute RMSE of ACE Estimation"
  ) +
  theme_minimal() +
  theme(legend.position = "right")

# panel B: relative RMSE plot
# RMSE scaled by true parameter value
p_rel_rmse <- ggplot(
  performance_summary,
  aes(x = n, y = rel_rmse, color = confound_label, group = confound_label)
) +
  geom_point(size = 3) +
  geom_line() +
  labs(
    x = "Sample size (n)",
    y = "Relative RMSE",
    color = "Confounding\nnon-linearity",
    title = "Relative Accuracy of ACE Estimation"
  ) +
  theme_minimal() +
  theme(legend.position = "right")

# panel C: coverage probability plot
# proportion of 95% CIs containing the true ACE
# dashed line at 0.95 = nominal coverage level
p_coverage <- ggplot(
  performance_summary,
  aes(x = n, y = coverage, color = confound_label, group = confound_label)
) +
  geom_hline(yintercept = 0.95, linetype = "dashed", color = "gray50") +
  geom_point(size = 3) +
  geom_line() +
  labs(
    x = "Sample size (n)",
    y = "Coverage (95% CI)",
    color = "Confounding\nnon-linearity",
    title = "Coverage Under Residual Confounding"
  ) +
  coord_cartesian(ylim = c(0, 1)) +
  theme_minimal() +
  theme(legend.position = "right")

# panel D: confidence interval width plot
# average width of 95% CIs (measures precision)
p_width <- ggplot(
  performance_summary,
  aes(x = n, y = width, color = confound_label, group = confound_label)
) +
  geom_point(size = 3) +
  geom_line() +
  labs(
    x = "Sample size (n)",
    y = "Average CI width",
    color = "Confounding\nnon-linearity",
    title = "Precision of CI"
  ) +
  theme_minimal() +
  theme(legend.position = "right")

# combine plots into 2x2 grid with shared legend using {cowplot}
# extract legend from one plot to use as shared legend
legend <- get_legend(
  p_rel_bias + theme(legend.position = "right")
)

# arrange panels and legend side by side
plot_grid(
  plot_grid(p_rel_bias, p_rel_rmse, p_coverage, p_width, ncol = 2, nrow = 2),
  legend,
  rel_widths = c(3, 0.4)
)