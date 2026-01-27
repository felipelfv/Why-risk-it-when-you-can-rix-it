library(marginaleffects)

# function to run one simulation replicate using the MISSPECIFIED model
# arguments:
#   n: sample size
#   gamma2: quadratic effect of confounder on outcome
run_one_rep <- function(n, gamma2) {
  # generate dataset for this replicate
  dat <- gen_data(n, gamma2)
  
  # fit misspecified model (omits X2^2 term, causing residual confounding)
  fit_misspec <- glm(y ~ x1 + x2, data = dat, family = binomial())
  
  # compute average causal effect (ACE) using {marginaleffects}
  ace_est <- avg_slopes(fit_misspec, variables = "x1")
  
  # point estimate, standard error, and 95% CI bounds
  data.frame(
    est = ace_est$estimate[1],
    se = ace_est$std.error[1],
    lo = ace_est$conf.low[1],
    hi = ace_est$conf.high[1]
  )
}

# function to compute the "true" ACE using the correctly specified model
# uses a large sample to approximate the population quantity
# arguments:
#   gamma2_val: quadratic effect of confounder on outcome
#   seed: random seed for reproducibility
compute_true_ace <- function(gamma2_val, seed = 12345) {
  set.seed(seed)
  
  # generate large dataset (n = 200,000) to approximate population
  bigdat <- gen_data(2e5, gamma2_val)
  
  # fit correctly specified model (includes X2^2 term)
  fit_correct <- glm(y ~ x1 + x2 + I(x2^2), data = bigdat, family = binomial())
  
  # true ACE estimate
  avg_slopes(fit_correct, variables = "x1")$estimate[1]
}