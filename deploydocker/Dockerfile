# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.9

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Configure Working Directory
WORKDIR /workspace
COPY . /workspace/

# Set up pip, poetry, and install dependencies
RUN pip install poetry
RUN poetry export --format requirements.txt --without-hashes -o /requirements.txt
RUN pip install --requirement /requirements.txt
RUN pip install --no-deps --use-feature=in-tree-build /workspace/.


# Patch behave
RUN patch -Nf -d "${VENV_PATH}/lib/python3.10/site-packages/behave/formatter" -p1 < /cucumber-format.patch

RUN rm -rf /workspace/*

WORKDIR /workspace


# Trick poetry into thinking it's inside the virtual environment
# This will make all poetry commands work naturally, even outside the virtual environment.
ENV VIRTUAL_ENV="${VENV_PATH}"
ENV PATH="${PATH}:${VENV_PATH}/bin/"

# On container start, the source code is loaded so we call poetry install so the venv knows where the local project's package/code lives.
ENTRYPOINT poetry install && bash

# Run pyright
RUN poetry run pyright . --lib

# Run unittests
RUN poetry run pytest --junitxml=pytest_results_pmd.xml

# Run behaviour testst
RUN poetry run behave tests/features --tags=-skip -f json.cucumber -o tests/behaviour/test-results.json