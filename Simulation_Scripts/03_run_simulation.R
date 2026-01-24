# Main Simulation 

library(foreach); library(doParallel); library(doRNG)

source("Simulation_Scripts/01_data_generation.R")                    
source("Simulation_Scripts/02_models.R")

# simulation parameters
nsim <- 100
ncore <- 1
master_seed <- 12345

# design matrix
n_values <- c(50, 100, 2000)
gamma2_values <- c(0, 0.3, 0.8)
gamma2_labels <- c("none", "mild", "severe")

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

# step 1: compute true values based on a large sample
# note that in our scenario this is possible to be done analytically
cat("Computing true ACE values\n")
true_ACE_values <- sapply(gamma2_values, compute_true_ace)
names(true_ACE_values) <- as.character(gamma2_values)
print(true_ACE_values)

# step 2: parallel processing
cl <- makeCluster(ncore)
registerDoParallel(cl)

# step 3: run simulation for all conditions
all_results <- vector("list", nrow(designs))

for (k in seq_len(nrow(designs))) {
  n_k <- designs$n[k]
  gamma2_k <- designs$gamma2[k]
  label_k <- as.character(designs$confound_label[k])
  
  cat("\nCondition:", label_k, "(gamma2 =", gamma2_k, "), n =", n_k, "\n")
  
  true_ACE_k <- true_ACE_values[as.character(gamma2_k)]
  
  # replications
  res_list <- foreach(
    i = seq_len(nsim),
    .packages = c("marginaleffects", "rvinecopulib")
  ) %dorng%
    {
      run_one_rep(n_k, gamma2_k)
    }
  
  res <- do.call(rbind, res_list)
  res$true_param <- true_ACE_k
  res$n <- n_k
  res$gamma2 <- gamma2_k
  res$confound_label <- label_k
  
  all_results[[k]] <- res
}

stopCluster(cl)

# for storing results
sim_results <- do.call(rbind, all_results)

# save
#saveRDS(sim_results, "Simulation_Scripts/sim_results.rds")
