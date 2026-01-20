# Master Script

# required packages
library(marginaleffects); library(simhelpers); library(rvinecopulib)
library(doParallel); library(doRNG); library(ggplot2); library(cowplot)

cat("\nSimulation workflow\n")

# source functions needed for the simulation
source("Simulation_Scripts/01_data_generation.R")
source("Simulation_Scripts/02_models.R")

# run simulation
cat("\nRunning simulation (sources 01 and 02)\n")
source("Simulation_Scripts/03_run_simulation.R")

# calculate performance metrics
cat("\nCalculating performance metrics\n")
source("Simulation_Scripts/04_performance_metrics.R")

# generate plots
cat("\nGenerating plots\n")
source("Simulation_Scripts/05_plots.R")

