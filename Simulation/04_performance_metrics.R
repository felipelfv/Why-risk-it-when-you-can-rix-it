library(simhelpers)

# load 
#sim_results <- readRDS("sim_results.rds")

# unique simulation conditions
conditions <- unique(sim_results[, c("n", "gamma2", "confound_label")])

# initialize list to store performance metrics for each condition
summary_list <- vector("list", nrow(conditions))

# loop over each condition to compute performance metrics
for (k in seq_len(nrow(conditions))) {
  # subset results for current condition
  res <- subset(
    sim_results,
    n == conditions$n[k] &
      gamma2 == conditions$gamma2[k]
  )
  
  # absolute performance metrics using {simhelpers}
  # includes bias, variance, MSE, and RMSE (with MCSEs)
  perf_abs <- calc_absolute(
    data = res,
    estimates = est,
    true_param = true_param,
    criteria = c("bias", "variance", "mse", "rmse")
  )
  
  # relative performance metrics
  # includes relative bias and relative RMSE (with MCSEs)
  perf_rel <- calc_relative(
    data = res,
    estimates = est,
    true_param = true_param,
    criteria = c("relative bias", "relative rmse")
  )
  
  # coverage and CI width metrics
  # evaluates 95% CI performance (with MCSEs)
  perf_cov <- calc_coverage(
    data = res,
    lower_bound = lo,
    upper_bound = hi,
    true_param = true_param,
    criteria = c("coverage", "width")
  )
  
  # combine condition info with all performance metrics
  summary_list[[k]] <- cbind(
    conditions[k, ],
    true_ace = unique(res$true_param),
    perf_abs,
    perf_rel,
    perf_cov
  )
}

# all conditions into final summary data frame
performance_summary <- do.call(rbind, summary_list)

# save
#saveRDS(performance_summary, "Simulation_Scripts/performance_summary.rds")