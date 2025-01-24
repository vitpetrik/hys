FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="$PATH:/root/.julia/bin"

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    libunwind-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Julia
RUN curl -fsSL https://install.julialang.org | sh -s -- --yes --default-channel lts --path=/root/.julia

RUN julia -e 'using Pkg; Pkg.add("IJulia")'
RUN julia -e 'using Pkg; Pkg.add("Plots")'
RUN julia -e 'using Pkg; Pkg.add("DifferentialEquations")'
RUN julia -e 'using Pkg; Pkg.add("ModelingToolkit")'
RUN julia -e 'using Pkg; Pkg.add("OrdinaryDiffEq")'
RUN julia -e 'using Pkg; Pkg.add("LazySets")'
RUN julia -e 'using Pkg; Pkg.add("JuMP")'
RUN julia -e 'using Pkg; Pkg.add("PATHSolver")'
RUN julia -e 'using Pkg; Pkg.add("SumOfSquares")'
RUN julia -e 'using Pkg; Pkg.add("DynamicPolynomials")'
RUN julia -e 'using Pkg; Pkg.add("MosekTools")'
RUN julia -e 'using Pkg; Pkg.add("CSDP")'
RUN julia -e 'using Pkg; Pkg.instantiate()'


# Install Quarto
RUN ARCH=$(dpkg --print-architecture) \
    && wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.40/quarto-1.6.40-linux-${ARCH}.deb -O /tmp/quarto.deb \
    && apt-get update \
    && apt-get install -y /tmp/quarto.deb \
    && rm /tmp/quarto.deb

# Verify installations
RUN julia --version && quarto --version

# Set working directory
WORKDIR /site

# Default command
CMD ["/bin/bash"]