library(foreach); library(doParallel); library(doRNG)

source("Simulation_Scripts/01_data_generation.R")                    
source("Simulation_Scripts/02_models.R")

# simulation parameters
nsim <- 100          # replications per condition
ncore <- 1           # CPU cores for parallel processing
master_seed <- 12345 # seed 

# simulation factors
n_values <- c(50, 100, 2000)              # sample sizes to evaluate
gamma2_values <- c(0, 0.3, 0.8)           # confounding severity levels
gamma2_labels <- c("none", "mild", "severe")  # labels for gamma2 levels

# full factorial design (3 x 3 = 9 conditions)
designs <- expand.grid(
  n = n_values,
  gamma2 = gamma2_values,
  stringsAsFactors = FALSE
)

# descriptive labels for confounding severity
designs$confound_label <- factor(
  designs$gamma2,
  levels = gamma2_values,
  labels = gamma2_labels
)

# compute true ACE values for each gamma2 condition
# these serve as the reference for evaluating estimator performance
cat("Computing true ACE values\n")
true_ACE_values <- sapply(gamma2_values, compute_true_ace)
names(true_ACE_values) <- as.character(gamma2_values)
print(true_ACE_values)

# parallel processing backend
cl <- makeCluster(ncore)
registerDoParallel(cl)

# run simulation across all conditions
all_results <- vector("list", nrow(designs))

for (k in seq_len(nrow(designs))) {
  # extract current condition parameters
  n_k <- designs$n[k]
  gamma2_k <- designs$gamma2[k]
  label_k <- as.character(designs$confound_label[k])
  
  cat("\nCondition:", label_k, "(gamma2 =", gamma2_k, "), n =", n_k, "\n")
  
  # true ACE for this condition
  true_ACE_k <- true_ACE_values[as.character(gamma2_k)]
  
  # run nsim replications in parallel with reproducible RNG via {doRNG}
  res_list <- foreach(
    i = seq_len(nsim),
    .packages = c("marginaleffects", "rvinecopulib")
  ) %dorng%
    {
      run_one_rep(n_k, gamma2_k)
    }
  
  # combine replications into data frame
  res <- do.call(rbind, res_list)
  
  # add condition metadata to results
  res$true_param <- true_ACE_k
  res$n <- n_k
  res$gamma2 <- gamma2_k
  res$confound_label <- label_k
  
  all_results[[k]] <- res
}

# clean up parallel backend
stopCluster(cl)

# all conditions into single data frame
sim_results <- do.call(rbind, all_results)

# save
#saveRDS(sim_results, "Simulation_Scripts/sim_results.rds")