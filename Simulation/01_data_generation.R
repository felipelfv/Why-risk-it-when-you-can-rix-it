library(rvinecopulib)

# fixed data-generating process (DGP) parameters
# parameters for treatment assignment model: X1 = alpha0 + alpha1*X2 + alpha2*X2^2 + error
alpha0 <- 0      # intercept for treatment equation
alpha1 <- 0.5    # linear effect of confounder X2 on treatment X1
alpha2 <- 0.2    # quadratic effect of confounder X2 on treatment X1

# parameters for outcome model: logit(P(Y=1)) = beta0 + beta1*X1 + gamma1*X2 + gamma2*X2^2
beta0 <- -0.5    # intercept for outcome equation
beta1 <- 0.7     # causal effect of treatment X1 on outcome Y (parameter of interest)
gamma1 <- -0.4   # linear effect of confounder X2 on outcome Y

# function to generate one dataset
# arguments:
#   n: sample size
#   gamma2: quadratic effect of confounder on outcome (varies by condition)
gen_data <- function(n, gamma2) {
  # generate independent uniform pairs using {rvinecopulib} (C++ backend)
  # this is equivalent to rnorm() but demonstrates system-level dependencies
  u <- rbicop(n, "indep", 0, numeric(0))
  
  # transform uniform marginals to standard normal via inverse CDF
  X2 <- qnorm(u[, 1])        # confounder
  error_X1 <- qnorm(u[, 2])  # error term for treatment equation
  
  # generate treatment variable (confounded by X2)
  X1 <- alpha0 + alpha1 * X2 + alpha2 * X2^2 + error_X1
  
  # compute true linear predictor for outcome model
  eta_true <- beta0 + beta1 * X1 + gamma1 * X2 + gamma2 * X2^2
  
  # convert to probability via logistic function
  p <- plogis(eta_true)
  
  # generate binary outcome
  y <- rbinom(n, size = 1, prob = p)
  
  # dataset with outcome and predictors
  data.frame(y = y, x1 = X1, x2 = X2)
}