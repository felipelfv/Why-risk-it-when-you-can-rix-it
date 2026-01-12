# Model Estimation Functions

# for running one simulation replicate with misspecified model
run_one_rep <- function(n, gamma2) {
  dat <- gen_data(n, gamma2)
  
  fit_misspec <- glm(y ~ x1 + x2, 
                     data = dat, 
                     family = binomial())
  
  ace_est <- avg_slopes(fit_misspec, variables = "x1")
  
  data.frame(
    est = ace_est$estimate[1],
    se  = ace_est$std.error[1],
    lo  = ace_est$conf.low[1],
    hi  = ace_est$conf.high[1]
  )
}

# for computing the true ACE using the correctly specified model
compute_true_ace <- function(gamma2_val, seed = 12345) {
  set.seed(seed)
  bigdat <- gen_data(2e5, gamma2_val)
  
  fit_correct <- glm(y ~ x1 + x2 + I(x2^2), 
                     data = bigdat, 
                     family = binomial())
  
  avg_slopes(fit_correct, variables = "x1")$estimate[1]
}