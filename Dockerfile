# Stage 1: Python Base Image
ARG PYTHON_VERSION=3.12.7
FROM python:${PYTHON_VERSION}-bullseye AS python-base

# Install Python packages
ARG poetry_version="1.8.3"
ENV POETRY_VERSION="${poetry_version}"

# Upgrade pip and install Poetry
RUN pip install --upgrade pip
RUN pip install "poetry==$POETRY_VERSION"

# Set the working directory
WORKDIR /

# Copy pyproject.toml
COPY pyproject.toml ./

# Configure Poetry and install dependencies
#RUN poetry config virtualenvs.create false
#RUN poetry install --no-interaction --no-ansi --no-root

# Install ipywidgets
#RUN pip install -U ipywidgets

# Stage 2: R Base Image
FROM r-base:latest AS r-base

# Install R packages
RUN Rscript -e 'install.packages(c("tsoutliers", "zoo"), repos="http://cran.rstudio.com/")'

# Stage 3: Final Image
FROM python:${PYTHON_VERSION}-bullseye

# Copy files from Python base
COPY --from=python-base / /

# Copy files from R base
COPY --from=r-base / /

# Install pyr2
RUN pip install pyr2==3.5.17

# Default command
CMD ["/bin/bash"]