# Visualize Results 

library(ggplot2); library(cowplot)

# Absolute bias plot
p_bias <- ggplot(
  performance_summary,
  aes(x = n, y = bias, color = confound_label, group = confound_label)
) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  geom_point(size = 3) +
  geom_line() +
  labs(
    x = "Sample size (n)",
    y = "Bias in ACE estimation",
    color = "Confounding\nnon-linearity",
    title = "Absolute Bias from Omitting X2²"
  ) +
  theme_minimal() +
  theme(legend.position = "right")

# Relative bias plot
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
    title = "Relative Bias from Omitting X2²"
  ) +
  theme_minimal() +
  theme(legend.position = "right")

# Absolute RMSE plot
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

# Relative RMSE plot
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

# Coverage plot
p_coverage <- ggplot(
  performance_summary,
  aes(x = n, y = coverage, color = confound_label, group = confound_label)
) +
  geom_hline(yintercept = 0.95, linetype = "dashed", color = "gray50") +
  geom_point(size = 3) +
  geom_line() +
  labs(
    x = "Sample size (n)",
    y = "Coverage of 95% CI",
    color = "Confounding\nnon-linearity",
    title = "CI Coverage Under Residual Confounding"
  ) +
  coord_cartesian(ylim = c(0, 1)) +
  theme_minimal() +
  theme(legend.position = "right")

# CI Width plot
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
    title = "Precision of Confidence Intervals"
  ) +
  theme_minimal() +
  theme(legend.position = "right")

# the 2x2 grid with all plots
legend <- get_legend(
  p_rel_bias + theme(legend.position = "right")
)

plot_grid(
  plot_grid(p_rel_bias, p_rel_rmse, p_coverage, p_width, ncol = 2, nrow = 2),
  legend,
  rel_widths = c(3, 0.4)
)