# Data Generation Function
#
# Generates one dataset for the simulation study

library(rvinecopulib)

# Fixed DGP parameters
alpha0 <- 0
alpha1 <- 0.5
alpha2 <- 0.2
beta0  <- -0.5
beta1  <- 0.7
gamma1 <- -0.4

gen_data <- function(n, gamma2) {
  # Generate independent uniform pairs via independence copula,

  # then transform to standard normal
  u <- rbicop(n, "indep", 0, numeric(0))
  X2 <- qnorm(u[, 1])
  error_X1 <- qnorm(u[, 2])

  X1 <- alpha0 + alpha1 * X2 + alpha2 * X2^2 + error_X1
  eta_true <- beta0 + beta1 * X1 + gamma1 * X2 + gamma2 * X2^2
  p <- plogis(eta_true)
  y <- rbinom(n, size = 1, prob = p)

  data.frame(y = y, x1 = X1, x2 = X2)
}
