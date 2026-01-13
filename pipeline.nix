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
    design_grid = makeRDerivation {
    name = "design_grid";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./functions/create_design_grid.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        # RIXPRESS_LOAD_DEPENDENCIES_HERE:design_grid
        source('functions/create_design_grid.R')
        design_grid <- create_design_grid(n_values = c(50, 100, 2000), gamma2_values = c(0, 0.3, 0.8), gamma2_labels = c('none', 'mild', 'severe'))
        saveRDS(design_grid, 'design_grid')"
    '';
  };

  true_ace_values = makeRDerivation {
    name = "true_ace_values";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./functions/gen_data.R ./functions/compute_true_ace.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        # RIXPRESS_LOAD_DEPENDENCIES_HERE:true_ace_values
        source('functions/gen_data.R')
        source('functions/compute_true_ace.R')
        true_ace_values <- sapply(c(0, 0.3, 0.8), compute_true_ace)
        saveRDS(true_ace_values, 'true_ace_values')"
    '';
  };

  sim_n50_none = makeRDerivation {
    name = "sim_n50_none";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./functions/gen_data.R ./functions/run_one_rep.R ./functions/run_condition.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        true_ace_values <- readRDS('${true_ace_values}/true_ace_values')
        source('functions/gen_data.R')
        source('functions/run_one_rep.R')
        source('functions/run_condition.R')
        sim_n50_none <- run_condition(n = 50, gamma2 = 0, confound_label = 'none', true_ace = true_ace_values[1], nsim = 100, master_seed = 12345)
        saveRDS(sim_n50_none, 'sim_n50_none')"
    '';
  };

  sim_n50_mild = makeRDerivation {
    name = "sim_n50_mild";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./functions/gen_data.R ./functions/run_one_rep.R ./functions/run_condition.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        true_ace_values <- readRDS('${true_ace_values}/true_ace_values')
        source('functions/gen_data.R')
        source('functions/run_one_rep.R')
        source('functions/run_condition.R')
        sim_n50_mild <- run_condition(n = 50, gamma2 = 0.3, confound_label = 'mild', true_ace = true_ace_values[2], nsim = 100, master_seed = 12345)
        saveRDS(sim_n50_mild, 'sim_n50_mild')"
    '';
  };

  sim_n50_severe = makeRDerivation {
    name = "sim_n50_severe";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./functions/gen_data.R ./functions/run_one_rep.R ./functions/run_condition.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        true_ace_values <- readRDS('${true_ace_values}/true_ace_values')
        source('functions/gen_data.R')
        source('functions/run_one_rep.R')
        source('functions/run_condition.R')
        sim_n50_severe <- run_condition(n = 50, gamma2 = 0.8, confound_label = 'severe', true_ace = true_ace_values[3], nsim = 100, master_seed = 12345)
        saveRDS(sim_n50_severe, 'sim_n50_severe')"
    '';
  };

  sim_n100_none = makeRDerivation {
    name = "sim_n100_none";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./functions/gen_data.R ./functions/run_one_rep.R ./functions/run_condition.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        true_ace_values <- readRDS('${true_ace_values}/true_ace_values')
        source('functions/gen_data.R')
        source('functions/run_one_rep.R')
        source('functions/run_condition.R')
        sim_n100_none <- run_condition(n = 100, gamma2 = 0, confound_label = 'none', true_ace = true_ace_values[1], nsim = 100, master_seed = 12345)
        saveRDS(sim_n100_none, 'sim_n100_none')"
    '';
  };

  sim_n100_mild = makeRDerivation {
    name = "sim_n100_mild";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./functions/gen_data.R ./functions/run_one_rep.R ./functions/run_condition.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        true_ace_values <- readRDS('${true_ace_values}/true_ace_values')
        source('functions/gen_data.R')
        source('functions/run_one_rep.R')
        source('functions/run_condition.R')
        sim_n100_mild <- run_condition(n = 100, gamma2 = 0.3, confound_label = 'mild', true_ace = true_ace_values[2], nsim = 100, master_seed = 12345)
        saveRDS(sim_n100_mild, 'sim_n100_mild')"
    '';
  };

  sim_n100_severe = makeRDerivation {
    name = "sim_n100_severe";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./functions/gen_data.R ./functions/run_one_rep.R ./functions/run_condition.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        true_ace_values <- readRDS('${true_ace_values}/true_ace_values')
        source('functions/gen_data.R')
        source('functions/run_one_rep.R')
        source('functions/run_condition.R')
        sim_n100_severe <- run_condition(n = 100, gamma2 = 0.8, confound_label = 'severe', true_ace = true_ace_values[3], nsim = 100, master_seed = 12345)
        saveRDS(sim_n100_severe, 'sim_n100_severe')"
    '';
  };

  sim_n2000_none = makeRDerivation {
    name = "sim_n2000_none";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./functions/gen_data.R ./functions/run_one_rep.R ./functions/run_condition.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        true_ace_values <- readRDS('${true_ace_values}/true_ace_values')
        source('functions/gen_data.R')
        source('functions/run_one_rep.R')
        source('functions/run_condition.R')
        sim_n2000_none <- run_condition(n = 2000, gamma2 = 0, confound_label = 'none', true_ace = true_ace_values[1], nsim = 100, master_seed = 12345)
        saveRDS(sim_n2000_none, 'sim_n2000_none')"
    '';
  };

  sim_n2000_mild = makeRDerivation {
    name = "sim_n2000_mild";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./functions/gen_data.R ./functions/run_one_rep.R ./functions/run_condition.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        true_ace_values <- readRDS('${true_ace_values}/true_ace_values')
        source('functions/gen_data.R')
        source('functions/run_one_rep.R')
        source('functions/run_condition.R')
        sim_n2000_mild <- run_condition(n = 2000, gamma2 = 0.3, confound_label = 'mild', true_ace = true_ace_values[2], nsim = 100, master_seed = 12345)
        saveRDS(sim_n2000_mild, 'sim_n2000_mild')"
    '';
  };

  sim_n2000_severe = makeRDerivation {
    name = "sim_n2000_severe";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./functions/gen_data.R ./functions/run_one_rep.R ./functions/run_condition.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        true_ace_values <- readRDS('${true_ace_values}/true_ace_values')
        source('functions/gen_data.R')
        source('functions/run_one_rep.R')
        source('functions/run_condition.R')
        sim_n2000_severe <- run_condition(n = 2000, gamma2 = 0.8, confound_label = 'severe', true_ace = true_ace_values[3], nsim = 100, master_seed = 12345)
        saveRDS(sim_n2000_severe, 'sim_n2000_severe')"
    '';
  };

  sim_results = makeRDerivation {
    name = "sim_results";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./functions/combine_sim_results.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        sim_n50_none <- readRDS('${sim_n50_none}/sim_n50_none')
        sim_n50_mild <- readRDS('${sim_n50_mild}/sim_n50_mild')
        sim_n50_severe <- readRDS('${sim_n50_severe}/sim_n50_severe')
        sim_n100_none <- readRDS('${sim_n100_none}/sim_n100_none')
        sim_n100_mild <- readRDS('${sim_n100_mild}/sim_n100_mild')
        sim_n100_severe <- readRDS('${sim_n100_severe}/sim_n100_severe')
        sim_n2000_none <- readRDS('${sim_n2000_none}/sim_n2000_none')
        sim_n2000_mild <- readRDS('${sim_n2000_mild}/sim_n2000_mild')
        sim_n2000_severe <- readRDS('${sim_n2000_severe}/sim_n2000_severe')
        source('functions/combine_sim_results.R')
        sim_results <- combine_sim_results(sim_n50_none, sim_n50_mild, sim_n50_severe, sim_n100_none, sim_n100_mild, sim_n100_severe, sim_n2000_none, sim_n2000_mild, sim_n2000_severe)
        saveRDS(sim_results, 'sim_results')"
    '';
  };

  performance_summary = makeRDerivation {
    name = "performance_summary";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./functions/compute_metrics.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        sim_results <- readRDS('${sim_results}/sim_results')
        source('functions/compute_metrics.R')
        performance_summary <- compute_metrics(sim_results)
        saveRDS(performance_summary, 'performance_summary')"
    '';
  };

  plots = makeRDerivation {
    name = "plots";
     src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./functions/make_plots.R ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      cp -r $src/* .
      Rscript -e "
        source('libraries.R')
        performance_summary <- readRDS('${performance_summary}/performance_summary')
        source('functions/make_plots.R')
        plots <- make_plots(performance_summary)
        saveRDS(plots, 'plots')"
    '';
  };

  article = defaultPkgs.stdenv.mkDerivation {
    name = "article";
    src = defaultPkgs.lib.fileset.toSource {
      root = ./.;
      fileset = defaultPkgs.lib.fileset.unions [ ./docs/article.qmd ./docs/appendix_a.qmd ./docs/appendix_b.qmd ./docs/_extensions ./docs/references.bib ];
    };
    buildInputs = defaultBuildInputs;
    configurePhase = defaultConfigurePhase;
    buildPhase = ''
      mkdir home
      export HOME=$PWD/home
      export RETICULATE_PYTHON=${defaultPkgs.python3}/bin/python

      substituteInPlace docs/article.qmd --replace-fail 'rixpress::rxp_load("performance_summary")' 'performance_summary <- rixpress::rxp_read("${performance_summary}")'
      substituteInPlace docs/article.qmd --replace-fail 'rixpress::rxp_load("sim_results")' 'sim_results <- rixpress::rxp_read("${sim_results}")'
      quarto render docs/article.qmd  --output-dir $out
    '';
  };

  # Generic default target that builds all derivations
  allDerivations = defaultPkgs.symlinkJoin {
    name = "all-derivations";
    paths = with builtins; attrValues { inherit design_grid true_ace_values sim_n50_none sim_n50_mild sim_n50_severe sim_n100_none sim_n100_mild sim_n100_severe sim_n2000_none sim_n2000_mild sim_n2000_severe sim_results performance_summary plots article; };
  };

in
{
  inherit design_grid true_ace_values sim_n50_none sim_n50_mild sim_n50_severe sim_n100_none sim_n100_mild sim_n100_severe sim_n2000_none sim_n2000_mild sim_n2000_severe sim_results performance_summary plots article;
  default = allDerivations;
}
