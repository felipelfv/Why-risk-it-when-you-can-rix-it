# Run Condition
#
# Runs all simulation replicates for one experimental condition

run_condition <- function(n, gamma2, confound_label, true_ace,
                          nsim = 100, master_seed = 12345) {

  set.seed(master_seed + n + as.integer(gamma2 * 1000))

  res_list <- lapply(seq_len(nsim), function(i) {
    run_one_rep(n, gamma2)
  })

  res <- do.call(rbind, res_list)
  res$true_param <- true_ace
  res$n <- n
  res$gamma2 <- gamma2
  res$confound_label <- confound_label

  res
}
