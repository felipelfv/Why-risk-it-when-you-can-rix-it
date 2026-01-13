# Main Simulation 

library(foreach)
library(doParallel)
library(doRNG)

step03_run_simulation <- function(
    out_dir = "outputs",
    nsim = 100,
    ncore = 1,
    master_seed = 12345,
    n_values = c(50, 100, 2000),
    gamma2_values = c(0, 0.3, 0.8),
    gamma2_labels = c("none", "mild", "severe")
) {
  if (!exists("gen_data", mode = "function")) stop("gen_data() not found")
  if (!exists("run_one_rep", mode = "function")) stop("run_one_rep() not found")
  if (!exists("compute_true_ace", mode = "function")) stop("compute_true_ace() not found")
  
  set.seed(master_seed)
  
  designs <- expand.grid(
    n = n_values,
    gamma2 = gamma2_values,
    stringsAsFactors = FALSE
  )
  designs$confound_label <- factor(
    designs$gamma2,
    levels = gamma2_values,
    labels = gamma2_labels
  )
  
  cat("Computing true ACE values\n")
  true_ACE_values <- sapply(gamma2_values, compute_true_ace)
  names(true_ACE_values) <- as.character(gamma2_values)
  
  if (ncore > 1) {
    cl <- makeCluster(ncore)
    on.exit(try(stopCluster(cl), silent = TRUE), add = TRUE)
    registerDoParallel(cl)
    registerDoRNG(master_seed)
  }
  
  all_results <- vector("list", nrow(designs))
  
  for (k in seq_len(nrow(designs))) {
    n_k      <- designs$n[k]
    gamma2_k <- designs$gamma2[k]
    label_k  <- as.character(designs$confound_label[k])
    
    cat("\nCondition:", label_k, "(gamma2 =", gamma2_k, "), n =", n_k, "\n")
    true_ACE_k <- true_ACE_values[as.character(gamma2_k)]
    
    if (ncore <= 1) {
      res_list <- lapply(seq_len(nsim), function(i) run_one_rep(n_k, gamma2_k))
    } else {
      res_list <- foreach(
        i = seq_len(nsim),
        .packages = c("marginaleffects", "rvinecopulib"),
        .export = c("gen_data", "run_one_rep", "compute_true_ace",
                    "alpha0", "alpha1", "alpha2", "beta0", "beta1", "gamma1")
      ) %dorng% {
        run_one_rep(n_k, gamma2_k)
      }
    }
    
    res <- do.call(rbind, res_list)
    res$true_param <- true_ACE_k
    res$n <- n_k
    res$gamma2 <- gamma2_k
    res$confound_label <- label_k
    
    all_results[[k]] <- res
  }
  
  sim_results <- do.call(rbind, all_results)
  cat("\nSimulation complete.\n")
  
  sim_results
}