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

COPY entrypoint.sh /deploydocker/entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/deploydocker/entrypoint.sh"]
# # Run pyright
# RUN poetry run pyright . --lib

# # Run unittests
# RUN poetry run pytest --junitxml=pytest_results_pmd.xml

# # Run behaviour testst
# RUN poetry run behave tests/features --tags=-skip -f json.cucumber -o tests/behaviour/test-results.json