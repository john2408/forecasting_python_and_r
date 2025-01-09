FROM rpy2/base-ubuntu:master-default

ARG poetry_version="1.8.3"

ENV POETRY_VERSION="${poetry_version}"

WORKDIR /

RUN pip install --upgrade pip

RUN pip install "poetry==$POETRY_VERSION"

COPY pyproject.toml ./

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --no-root

RUN pip install -U ipywidgets

# Start docker interactive session at bash
CMD ["/bin/bash"]