FROM ubuntu:latest

RUN apt update -y && apt install -y curl

# Install the Nix package manager (Determinate Systems installer)
RUN curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux \
  --extra-conf "sandbox = false" \
  --init none \
  --no-confirm

ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"
ENV user=root

# rstats-on-nix binary cache -> download precompiled packages instead of building from source
RUN mkdir -p /root/.config/nix && \
    echo "substituters = https://cache.nixos.org https://rstats-on-nix.cachix.org" > /root/.config/nix/nix.conf && \
    echo "trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= rstats-on-nix.cachix.org-1:vdiiVgocg6WeJrODIqdprZRUrhi1JzhBnXv7aWI6+F0=" >> /root/.config/nix/nix.conf

WORKDIR /project

# Bring in the whole compendium: pinned default.nix, .Rprofile, Manuscript/, Simulation/, etc.
COPY . /project

# Build the exact, pinned environment from the committed default.nix
RUN nix-build

# Render the APA7 manuscript inside the reproducible Nix shell.
# (Simulation result .rds files are already committed, so a render alone works.)
# To re-run the full simulation first, use:
#   CMD nix-shell default.nix --run "Rscript Simulation/06_run_all.R && quarto render Manuscript/article.qmd"
CMD nix-shell default.nix --run "quarto render Manuscript/article.qmd"
