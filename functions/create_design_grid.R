# Create Design Grid
#
# Creates the experimental design grid for the simulation study

create_design_grid <- function(n_values = c(50, 100, 2000),
                               gamma2_values = c(0, 0.3, 0.8),
                               gamma2_labels = c("none", "mild", "severe")) {

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

  designs
}
