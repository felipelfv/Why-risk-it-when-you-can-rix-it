# Visualize Results 

library(ggplot2)
library(cowplot)

make_plots <- function(performance_summary) {
  
  if (!is.data.frame(performance_summary)) {
    stop("make_plots(): 'performance_summary' must be a data.frame.")
  }
  
  p_rel_bias <- ggplot(performance_summary,
                       aes(x = n, y = rel_bias, color = confound_label, group = confound_label)) +
    geom_hline(yintercept = 1, linetype = "dashed") +
    geom_point(size = 3) + geom_line() +
    labs(x = "Sample size (n)", y = "Relative Bias", color = "Confounding\nnon-linearity",
         title = "Relative Bias from Omitting X^2") +
    theme_minimal() + theme(legend.position = "right")
  
  p_rel_rmse <- ggplot(performance_summary,
                       aes(x = n, y = rel_rmse, color = confound_label, group = confound_label)) +
    geom_point(size = 3) + geom_line() +
    labs(x = "Sample size (n)", y = "Relative RMSE", color = "Confounding\nnon-linearity",
         title = "Relative Accuracy of ACE Estimation") +
    theme_minimal() + theme(legend.position = "right")
  
  p_coverage <- ggplot(performance_summary,
                       aes(x = n, y = coverage, color = confound_label, group = confound_label)) +
    geom_hline(yintercept = 0.95, linetype = "dashed") +
    geom_point(size = 3) + geom_line() +
    labs(x = "Sample size (n)", y = "Coverage of 95% CI", color = "Confounding\nnon-linearity",
         title = "CI Coverage Under Residual Confounding") +
    coord_cartesian(ylim = c(0, 1)) +
    theme_minimal() + theme(legend.position = "right")
  
  p_width <- ggplot(performance_summary,
                    aes(x = n, y = width, color = confound_label, group = confound_label)) +
    geom_point(size = 3) + geom_line() +
    labs(x = "Sample size (n)", y = "Average CI width", color = "Confounding\nnon-linearity",
         title = "Precision of Confidence Intervals") +
    theme_minimal() + theme(legend.position = "right")
  
  legend <- get_legend(p_rel_bias + theme(legend.position = "right"))
  grid_plot <- plot_grid(
    plot_grid(p_rel_bias + theme(legend.position = "none"), 
              p_rel_rmse + theme(legend.position = "none"), 
              p_coverage + theme(legend.position = "none"), 
              p_width + theme(legend.position = "none"), 
              ncol = 2, nrow = 2),
    legend,
    rel_widths = c(3, 0.4)
  )
  
  message("Plots created.")
  
  list(
    rel_bias = p_rel_bias,
    rel_rmse = p_rel_rmse,
    coverage = p_coverage,
    ci_width = p_width,
    grid     = grid_plot
  )
}