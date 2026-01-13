# Combine Simulation Results
#
# Combines results from all simulation conditions into one data.frame

combine_sim_results <- function(...) {
  results_list <- list(...)
  do.call(rbind, results_list)
}
