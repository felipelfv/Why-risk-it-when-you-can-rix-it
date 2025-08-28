library(rix)

rix(
  date = "2025-08-25",
  r_pkgs = c("rix", "quarto"),
  # in case we want to illustrate python
  #py_conf = list(
  #  py_version = "3.13",
  #  py_pkgs = c("pandas", "polars", "pyarrow")
  #),
  ide = "none",
  project_path = ".",
  overwrite = TRUE
)
