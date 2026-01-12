# Master Script

# required packages
library(marginaleffects); library(simhelpers); library(rvinecopulib)
library(doParallel); library(doRNG); library(ggplot2); library(cowplot)

cat("Starting simulation workflow...\n\n")

# step 1: run simulation
cat("Step 1: Running simulation (sources 01 and 02)\n")
source("Simulation_Scripts/03_run_simulation.R")

# step 2: calculate performance metrics
cat("\nStep 2: Calculating performance metrics\n")
source("Simulation_Scripts/04_performance_metrics.R")

# step 3: generate plots
cat("\nStep 3: Generating plots\n")
source("Simulation_Scripts/05_plots.R")

