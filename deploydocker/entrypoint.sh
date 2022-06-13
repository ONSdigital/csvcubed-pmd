poetry run pyrght . --lib
poetry run pytest --junitxml=pytest_results_pmd.xml
poetry run behave tests/features --tags=-skip -f json.cucumber -o tests/behaviour/test-results.json