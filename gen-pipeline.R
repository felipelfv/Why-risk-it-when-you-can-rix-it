# gen-pipeline.R

library(rixpress)

list(
  
  rxp_r(
    name = sim_results,
    expr = step03_run_simulation(
      nsim = 100,
      ncore = 1,
      master_seed = 12345,
      n_values = c(50, 100, 2000),
      gamma2_values = c(0, 0.3, 0.8),
      gamma2_labels = c("none", "mild", "severe")
    ),
    user_functions = c(
      "Simulation_Scripts/01_data_generation.R",
      "Simulation_Scripts/02_models.R",
      "Simulation_Scripts/03_run_simulation.R"
    )
  ),
  
  rxp_r(
    name = performance_summary,
    expr = compute_metrics(sim_results),
    user_functions = "Simulation_Scripts/04_performance_metrics.R"
  ),
  
  rxp_r(
    name = plots,
    expr = make_plots(performance_summary),
    user_functions = "Simulation_Scripts/05_plots.R"
  )
  
) |>
  rxp_populate(
    project_path = ".",
    build = TRUE,
    verbose = 1
  )