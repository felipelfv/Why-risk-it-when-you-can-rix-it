# Run One Simulation Replicate
#
# Runs one simulation replicate with misspecified model

library(marginaleffects)

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
