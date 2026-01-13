let
  default = import ./default.nix;
  defaultPkgs = default.pkgs;
  defaultShell = default.shell;
  defaultBuildInputs = defaultShell.buildInputs;
  defaultConfigurePhase = ''
    cp ${./_rixpress/default_libraries.R} libraries.R
    mkdir -p $out  
    mkdir -p .julia_depot  
    export JULIA_DEPOT_PATH=$PWD/.julia_depot  
    export HOME_PATH=$PWD
  '';
  
  # Function to create R derivations
  makeRDerivation = { name, buildInputs, configurePhase, buildPhase, src ? null }:
    defaultPkgs.stdenv.mkDerivation {
      inherit name src;
      dontUnpack = true;
      inherit buildInputs configurePhase buildPhase;
      installPhase = ''
        cp ${name} $out/
      '';
    };

  # Define all derivations
    sim_results = makeRDerivation {
    name = "sim_results";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./Simulation_Scripts/01_data_generation.R ./Simulation_Scripts/02_models.R ./Simulation_Scripts/03_run_simulation.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        # RIXPRESS_LOAD_DEPENDENCIES_HERE:sim_results
        source('Simulation_Scripts/01_data_generation.R')
        source('Simulation_Scripts/02_models.R')
        source('Simulation_Scripts/03_run_simulation.R')
        sim_results <- step03_run_simulation(nsim = 100, ncore = 1, master_seed = 12345, n_values = c(50, 100, 2000), gamma2_values = c(0, 0.3, 0.8), gamma2_labels = c('none', 'mild', 'severe'))
        saveRDS(sim_results, 'sim_results')"
    '';
  };

  performance_summary = makeRDerivation {
    name = "performance_summary";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./Simulation_Scripts/04_performance_metrics.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        sim_results <- readRDS('${sim_results}/sim_results')
        source('Simulation_Scripts/04_performance_metrics.R')
        performance_summary <- compute_metrics(sim_results)
        saveRDS(performance_summary, 'performance_summary')"
    '';
  };

  plots = makeRDerivation {
    name = "plots";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./Simulation_Scripts/05_plots.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        performance_summary <- readRDS('${performance_summary}/performance_summary')
        source('Simulation_Scripts/05_plots.R')
        plots <- make_plots(performance_summary)
        saveRDS(plots, 'plots')"
    '';
  };

  # Generic default target that builds all derivations
  allDerivations = defaultPkgs.symlinkJoin {
    name = "all-derivations";
    paths = with builtins; attrValues { inherit sim_results performance_summary plots; };
  };

in
{
  inherit sim_results performance_summary plots;
  default = allDerivations;
}
