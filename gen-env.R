library(rix)

rix(
  date = "2025-08-25",
  r_pkgs = c(
    "rix",
    "quarto",
    "knitr",
    "marginaleffects",
    "simhelpers",
    "ggplot2",
    "doParallel",
    "doRNG",
    "cowplot",
    "dplyr"
  ),
  system_pkgs = c("quarto"),
  #system_pkgs = c("quarto", "git", "pandoc", "librsvg", "typst"),
  #tex_pkgs = c("pgf", "standalone", "apa7", "scalerel", "threeparttable", "endfloat"), # continue this
  tex_pkgs = c(
    "amsmath",
    "ninecolors",
    "apa7",
    "scalerel",
    "threeparttable",
    "threeparttablex",
    "endfloat",
    "environ",
    "multirow",
    "tcolorbox",
    "pdfcol",
    "tikzfill",
    "fontawesome5",
    "framed",
    "newtx",
    "fontaxes",
    "xstring",
    "wrapfig",
    "tabularray",
    "siunitx",
    "fvextra",
    "geometry",
    "setspace",
    "fancyvrb",
    "anyfontsize"
  ),
  # in case we want to illustrate python
  #py_conf = list(
  #  py_version = "3.13",
  #  py_pkgs = c("pandas", "polars", "pyarrow")
  #),
  ide = "rstudio",
  project_path = ".",
  overwrite = TRUE
)
