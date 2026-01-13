# gen-pipeline.R
#
# Rixpress pipeline for the simulation study
# Creates 15 derivations with 9 parallel simulation conditions

library(rixpress)

# Define simulation parameters
nsim <- 100
master_seed <- 12345

# Helper to get function paths
fn <- function(x) paste0("functions/", x, ".R")

list(
  # 1. Create design grid
  rxp_r(
    name = design_grid,
    expr = create_design_grid(
      n_values = c(50, 100, 2000),
      gamma2_values = c(0, 0.3, 0.8),
      gamma2_labels = c("none", "mild", "severe")
    ),
    user_functions = fn("create_design_grid")
  ),

  # 2. Compute true ACE values for each gamma2 level
  rxp_r(
    name = true_ace_values,
    expr = sapply(c(0, 0.3, 0.8), compute_true_ace),
    user_functions = c(fn("gen_data"), fn("compute_true_ace"))
  ),

  # 3-11. Run simulation for each of 9 conditions (3 n × 3 gamma2)
  # n=50, gamma2=0 (none)
  rxp_r(
    name = sim_n50_none,
    expr = run_condition(
      n = 50,
      gamma2 = 0,
      confound_label = "none",
      true_ace = true_ace_values[1],
      nsim = 100,
      master_seed = 12345
    ),
    user_functions = c(fn("gen_data"), fn("run_one_rep"), fn("run_condition"))
  ),

  # n=50, gamma2=0.3 (mild)
  rxp_r(
    name = sim_n50_mild,
    expr = run_condition(
      n = 50,
      gamma2 = 0.3,
      confound_label = "mild",
      true_ace = true_ace_values[2],
      nsim = 100,
      master_seed = 12345
    ),
    user_functions = c(fn("gen_data"), fn("run_one_rep"), fn("run_condition"))
  ),

  # n=50, gamma2=0.8 (severe)
  rxp_r(
    name = sim_n50_severe,
    expr = run_condition(
      n = 50,
      gamma2 = 0.8,
      confound_label = "severe",
      true_ace = true_ace_values[3],
      nsim = 100,
      master_seed = 12345
    ),
    user_functions = c(fn("gen_data"), fn("run_one_rep"), fn("run_condition"))
  ),

  # n=100, gamma2=0 (none)
  rxp_r(
    name = sim_n100_none,
    expr = run_condition(
      n = 100,
      gamma2 = 0,
      confound_label = "none",
      true_ace = true_ace_values[1],
      nsim = 100,
      master_seed = 12345
    ),
    user_functions = c(fn("gen_data"), fn("run_one_rep"), fn("run_condition"))
  ),

  # n=100, gamma2=0.3 (mild)
  rxp_r(
    name = sim_n100_mild,
    expr = run_condition(
      n = 100,
      gamma2 = 0.3,
      confound_label = "mild",
      true_ace = true_ace_values[2],
      nsim = 100,
      master_seed = 12345
    ),
    user_functions = c(fn("gen_data"), fn("run_one_rep"), fn("run_condition"))
  ),

  # n=100, gamma2=0.8 (severe)
  rxp_r(
    name = sim_n100_severe,
    expr = run_condition(
      n = 100,
      gamma2 = 0.8,
      confound_label = "severe",
      true_ace = true_ace_values[3],
      nsim = 100,
      master_seed = 12345
    ),
    user_functions = c(fn("gen_data"), fn("run_one_rep"), fn("run_condition"))
  ),

  # n=2000, gamma2=0 (none)
  rxp_r(
    name = sim_n2000_none,
    expr = run_condition(
      n = 2000,
      gamma2 = 0,
      confound_label = "none",
      true_ace = true_ace_values[1],
      nsim = 100,
      master_seed = 12345
    ),
    user_functions = c(fn("gen_data"), fn("run_one_rep"), fn("run_condition"))
  ),

  # n=2000, gamma2=0.3 (mild)
  rxp_r(
    name = sim_n2000_mild,
    expr = run_condition(
      n = 2000,
      gamma2 = 0.3,
      confound_label = "mild",
      true_ace = true_ace_values[2],
      nsim = 100,
      master_seed = 12345
    ),
    user_functions = c(fn("gen_data"), fn("run_one_rep"), fn("run_condition"))
  ),

  # n=2000, gamma2=0.8 (severe)
  rxp_r(
    name = sim_n2000_severe,
    expr = run_condition(
      n = 2000,
      gamma2 = 0.8,
      confound_label = "severe",
      true_ace = true_ace_values[3],
      nsim = 100,
      master_seed = 12345
    ),
    user_functions = c(fn("gen_data"), fn("run_one_rep"), fn("run_condition"))
  ),

  # 12. Combine all simulation results
  rxp_r(
    name = sim_results,
    expr = combine_sim_results(
      sim_n50_none,
      sim_n50_mild,
      sim_n50_severe,
      sim_n100_none,
      sim_n100_mild,
      sim_n100_severe,
      sim_n2000_none,
      sim_n2000_mild,
      sim_n2000_severe
    ),
    user_functions = fn("combine_sim_results")
  ),

  # 13. Compute performance metrics
  rxp_r(
    name = performance_summary,
    expr = compute_metrics(sim_results),
    user_functions = fn("compute_metrics")
  ),

  # 14. Generate plots
  rxp_r(
    name = plots,
    expr = make_plots(performance_summary),
    user_functions = fn("make_plots")
  ),

  # 15. Render Quarto article
  rxp_qmd(
    name = article,
    qmd_file = "docs/article.qmd",
    additional_files = c(
      "docs/appendix_a.qmd",
      "docs/appendix_b.qmd",
      "docs/_extensions",
      "docs/references.bib"
    )
  )
) |>
  rxp_populate(
    project_path = ".",
    build = TRUE,
    verbose = 1
  )
