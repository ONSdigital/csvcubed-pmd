Feature: Testing the csvw command group in the CLI

  Scenario: The `find-where` command should find return CSV-Ws matching an ASK query.
    Given the existing test-case files "dcatcli/*"
    When the pmdutils command CLI is run with "csvw find-where 'ASK WHERE { ?s a <http://www.w3.org/2004/02/skos/core#ConceptScheme>. }'"
    Then the CLI should succeed
    And the CLI should print "month.csv-metadata.json"

  Scenario: The `find-where` command should return CSV-Ws which do not match an ASK query when the negate option is set.
    Given the existing test-case files "dcatcli/*"
    When the pmdutils command CLI is run with "csvw find-where --negate 'ASK WHERE { ?s a <http://www.w3.org/2004/02/skos/core#ConceptScheme>. }'"
    Then the CLI should succeed
    And the CLI should print "4g-coverage-v0-4-10.csv-metadata.json"
