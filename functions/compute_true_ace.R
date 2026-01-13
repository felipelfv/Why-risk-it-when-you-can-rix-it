# Compute True ACE
#
# Computes the true ACE using correctly specified model on large sample

library(marginaleffects)

compute_true_ace <- function(gamma2_val, seed = 12345) {
  set.seed(seed)
  bigdat <- gen_data(2e5, gamma2_val)

  fit_correct <- glm(y ~ x1 + x2 + I(x2^2),
                     data = bigdat,
                     family = binomial())

  avg_slopes(fit_correct, variables = "x1")$estimate[1]
}
