# Performance Metrics

library(simhelpers)

# unique conditions
conditions <- unique(sim_results[, c("n", "gamma2", "confound_label")])

# calculate metrics for each condition
summary_list <- vector("list", nrow(conditions))

for (k in seq_len(nrow(conditions))) {
  res <- subset(
    sim_results,
    n == conditions$n[k] &
      gamma2 == conditions$gamma2[k]
  )
  
  perf_abs <- calc_absolute(
    data = res,
    estimates = est,
    true_param = true_param,
    criteria = c("bias", "variance", "mse", "rmse")
  )
  
  perf_rel <- calc_relative(
    data = res,
    estimates = est,
    true_param = true_param,
    criteria = c("relative bias", "relative rmse")
  )
  
  perf_cov <- calc_coverage(
    data = res,
    lower_bound = lo,
    upper_bound = hi,
    true_param = true_param,
    criteria = c("coverage", "width")
  )
  
  summary_list[[k]] <- cbind(
    conditions[k, ],
    true_ace = unique(res$true_param),
    perf_abs,
    perf_rel,
    perf_cov
  )
}

performance_summary <- do.call(rbind, summary_list)