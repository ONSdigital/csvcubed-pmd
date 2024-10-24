Feature: Testing the csvw command group in the CLI

  Scenario: The `pmdify` command should remove DCAT metadata from the CSV-W it is processing.
    Given the existing test-case files "dcatcli/*"
    When the pmdutils command CLI is run with "dcat pmdify 4g-coverage-v0-4-10.csv-metadata.json http://base-uri http://data-graph-uri http://catalog-metadata-graph-uri"
    Then the CLI should succeed
    # And csvlint validation of
    #  "4g-coverage-v0-4-10.csv-metadata.json" should succeed
    And csv2rdf on "4g-coverage-v0-4-10.csv-metadata.json" should succeed
    And the RDF should not contain any URIs in the "http://www.w3.org/ns/dcat#" namespace
    And the RDF should contain
      """
      <http://base-uri/4g-coverage.csv#dataset> a <http://purl.org/linked-data/cube#DataSet>.
      """

  Scenario: The `pmdify` command should create a separate N-Quads file containing pmd-style catalog metadata using csvcubed v0.4.10.
    Given the existing test-case files "dcatcli/*"
    When the pmdutils command CLI is run with "dcat pmdify 4g-coverage-v0-4-10.csv-metadata.json http://base-uri http://data-graph-uri http://catalog-metadata-graph-uri"
    Then the CLI should succeed
    And the file at "4g-coverage-v0-4-10.csv-metadata.json.nq" should exist
    Given the N-Quads contained in "4g-coverage-v0-4-10.csv-metadata.json.nq"
    Then the RDF should contain
      """
      @prefix dcat: <http://www.w3.org/ns/dcat#> .
      @prefix dct: <http://purl.org/dc/terms/> .
      @prefix pmdcat: <http://publishmydata.com/pmdcat#> .
      @prefix void: <http://rdfs.org/ns/void#> .
      @prefix foaf: <http://xmlns.com/foaf/0.1/> .
      @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
      @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

      <http://gss-data.org.uk/catalog/datasets> dcat:record <http://base-uri/4g-coverage.csv#dataset-catalog-record> .

      <http://base-uri/4g-coverage.csv#dataset-catalog-entry> a pmdcat:Dataset;
      rdfs:label "4G coverage"@en;
      pmdcat:datasetContents <http://base-uri/4g-coverage.csv#dataset>;
      pmdcat:graph <http://data-graph-uri>;
      pmdcat:metadataGraph <http://catalog-metadata-graph-uri>;
      dct:creator <https://www.gov.uk/government/organisations/ofcom>;
      pmdcat:markdownDescription "This dataset shows the percentage of geographic areas with 4G signal outdoors from at least 1 operator (signal threshold: 105dBm), in the UK, as of January 2024."^^<https://www.w3.org/ns/iana/media-types/text/markdown#Resource>;
      dct:identifier "4G coverage";
      dct:issued "2023-03-31T12:10:26.937229"^^xsd:dateTime;
      dct:modified "2024-09-23T10:30:00"^^xsd:dateTime;
      dct:publisher <https://www.gov.uk/government/organisations/office-for-national-statistics>;
      dct:title "4G coverage"@en;
      void:sparqlEndpoint <https://staging.gss-data.org.uk/sparql>;
      dcat:keyword "broadband-mobile-coverage"@en, "combined-authority"@en, "connectivity"@en, "county"@en, "local-authority"@en, "region"@en, "subnational"@en;
      dcat:theme <https://www.ons.gov.uk/businessindustryandtrade/itandinternetindustry>.

      <http://base-uri/4g-coverage.csv#dataset-catalog-record> a dcat:CatalogRecord;
      rdfs:label "4G coverage"@en;
      pmdcat:metadataGraph <http://catalog-metadata-graph-uri>;
      dct:title "4G coverage"@en;
      foaf:primaryTopic <http://base-uri/4g-coverage.csv#dataset-catalog-entry> .

      # the qb:Dataset needs to be a pmdcat:Dataset too since it's referenced by a catalog record.
      <http://base-uri/4g-coverage.csv#dataset> a <http://publishmydata.com/pmdcat#DataCube>.
      """


  Scenario: The `pmdify` command should create a separate N-Quads file containing pmd-style catalog metadata using csvcubed v0.5.1.
    Given the existing test-case files "dcatcli/*"
    When the pmdutils command CLI is run with "dcat pmdify 4g-coverage-v0-5-1.csv-metadata.json http://base-uri http://data-graph-uri http://catalog-metadata-graph-uri"
    Then the CLI should succeed
    And the file at "4g-coverage-v0-5-1.csv-metadata.json.nq" should exist
    Given the N-Quads contained in "4g-coverage-v0-5-1.csv-metadata.json.nq"
    Then the RDF should contain
      """
      @prefix dcat: <http://www.w3.org/ns/dcat#> .
      @prefix dct: <http://purl.org/dc/terms/> .
      @prefix pmdcat: <http://publishmydata.com/pmdcat#> .
      @prefix void: <http://rdfs.org/ns/void#> .
      @prefix foaf: <http://xmlns.com/foaf/0.1/> .
      @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
      @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

      <http://gss-data.org.uk/catalog/datasets> dcat:record <http://base-uri/4g-coverage.csv#dataset-catalog-record> .

      <http://base-uri/4g-coverage.csv#dataset-catalog-entry> a pmdcat:Dataset;
      rdfs:label "4G coverage"@en;
      pmdcat:datasetContents <http://base-uri/4g-coverage.csv#qbDataSet>;
      pmdcat:graph <http://data-graph-uri>;
      pmdcat:metadataGraph <http://catalog-metadata-graph-uri>;
      dct:creator <https://www.gov.uk/government/organisations/ofcom>;
      pmdcat:markdownDescription "This dataset shows the percentage of geographic areas with 4G signal outdoors from at least 1 operator (signal threshold: 105dBm), in the UK, as of January 2024."^^<https://www.w3.org/ns/iana/media-types/text/markdown#Resource>;
      dct:identifier "4G coverage";
      dct:issued "2023-03-31T12:10:26.937229"^^xsd:dateTime;
      dct:modified "2024-09-23T10:30:00"^^xsd:dateTime;
      dct:publisher <https://www.gov.uk/government/organisations/office-for-national-statistics>;
      dct:title "4G coverage"@en;
      void:sparqlEndpoint <https://staging.gss-data.org.uk/sparql>;
      dcat:keyword "broadband-mobile-coverage"@en, "combined-authority"@en, "connectivity"@en, "county"@en, "local-authority"@en, "region"@en, "subnational"@en;
      dcat:theme <https://www.ons.gov.uk/businessindustryandtrade/itandinternetindustry>.

      <http://base-uri/4g-coverage.csv#dataset-catalog-record> a dcat:CatalogRecord;
      rdfs:label "4G coverage"@en;
      pmdcat:metadataGraph <http://catalog-metadata-graph-uri>;
      dct:title "4G coverage"@en;
      foaf:primaryTopic <http://base-uri/4g-coverage.csv#dataset-catalog-entry> .

      # the qb:Dataset needs to be a pmdcat:Dataset too since it's referenced by a catalog record.
      <http://base-uri/4g-coverage.csv#qbDataSet> a <http://publishmydata.com/pmdcat#DataCube>.
      """

  Scenario: The `pmdify` command should add the `pmdcat:Dataset` type to `qb:DataSet`s.
    Given the existing test-case files "dcatcli/*"
    When the pmdutils command CLI is run with "dcat pmdify 4g-coverage-v0-4-10.csv-metadata.json http://base-uri http://data-graph-uri http://catalog-metadata-graph-uri"
    Then the CLI should succeed
    And the file at "4g-coverage-v0-4-10.csv-metadata.json.nq" should exist
    Given the N-Quads contained in "4g-coverage-v0-4-10.csv-metadata.json.nq"
    Then the RDF should contain
      """
      <http://base-uri/4g-coverage.csv#dataset> a <http://publishmydata.com/pmdcat#DataCube>.
      """

  Scenario: The `pmdify` command should add the `pmdcat:ConceptScheme` type to `skos:ConceptScheme`s
    Given the existing test-case files "dcatcli/*"
    When the pmdutils command CLI is run with "dcat pmdify month.csv-metadata.json http://base-uri http://data-graph-uri http://catalog-metadata-graph-uri"
    Then the CLI should succeed
    And the file at "month.csv-metadata.json.nq" should exist
    Given the N-Quads contained in "month.csv-metadata.json.nq"
    Then the RDF should contain
      """
      <http://base-uri/month.csv#code-list> a <http://publishmydata.com/pmdcat#ConceptScheme>.
      """


  Scenario: The `pmdify` command should insert `qb:DataSet`s into the datasets catalogue.
    Given the existing test-case files "dcatcli/*"
    When the pmdutils command CLI is run with "dcat pmdify 4g-coverage-v0-4-10.csv-metadata.json http://base-uri http://data-graph-uri http://catalog-metadata-graph-uri"
    Then the CLI should succeed
    And the file at "4g-coverage-v0-4-10.csv-metadata.json.nq" should exist
    Given the N-Quads contained in "4g-coverage-v0-4-10.csv-metadata.json.nq"
    Then the RDF should contain
      """
      @prefix dcat: <http://www.w3.org/ns/dcat#> .

      <http://gss-data.org.uk/catalog/datasets> dcat:record <http://base-uri/4g-coverage.csv#dataset-catalog-record> .
      """

  Scenario: The `pmdify` command should insert `skos:ConceptSchemes`s into the vocabularies catalogue.
    Given the existing test-case files "dcatcli/*"
    When the pmdutils command CLI is run with "dcat pmdify month.csv-metadata.json http://base-uri http://data-graph-uri http://catalog-metadata-graph-uri"
    Then the CLI should succeed
    And the file at "month.csv-metadata.json.nq" should exist
    Given the N-Quads contained in "month.csv-metadata.json.nq"
    Then the RDF should contain
      """
      @prefix dcat: <http://www.w3.org/ns/dcat#> .

      <http://gss-data.org.uk/catalog/vocabularies> dcat:record <http://base-uri/month.csv#code-list-catalog-record> .
      """

  # Scenario: The `pmdify` command should work on legacy code-list `itis-industry.csv`.
  #   Given the existing test-case files "dcatcli/*"
  #   When the pmdutils command CLI is run with "dcat pmdify itis-industry.csv-metadata.json http://base-uri http://data-graph-uri http://catalog-metadata-graph-uri"
  #   Then the CLI should succeed
  #   And csvlint validation of "itis-industry.csv-metadata.json" should succeed
  #   And csv2rdf on "itis-industry.csv-metadata.json" should succeed
  #   And the RDF should not contain any reference to "http://gss-data.org.uk/data/gss_data/trade/ons-international-trade-in-services#scheme/itis-industry/dataset"
  #   And the RDF should not contain any instances of "http://www.w3.org/ns/dcat#Dataset"
  #   And the RDF should not contain any instances of "http://publishmydata.com/pmdcat#Dataset"
  #   And the RDF should not contain any instances of "http://www.w3.org/ns/dcat#CatalogRecord"
  #   And the RDF should contain 1 instance(s) of "http://www.w3.org/2004/02/skos/core#ConceptScheme"
  #   And the RDF should not contain any URIs in the "http://publishmydata.com/pmdcat#" namespace
  #   Given the N-Quads contained in "itis-industry.csv-metadata.json.nq"
  #   Then the RDF should contain 1 instance(s) of "http://publishmydata.com/pmdcat#ConceptScheme"
  #   And the RDF should contain 1 instance(s) of "http://www.w3.org/ns/dcat#CatalogRecord"
  #   And the RDF should contain 1 instance(s) of "http://www.w3.org/ns/dcat#Dataset"
  #   And the RDF should contain
  #     """
  #     @prefix dcat: <http://www.w3.org/ns/dcat#>.
  #     @prefix foaf: <http://xmlns.com/foaf/0.1/>.
  #     @prefix pmdcat: <http://publishmydata.com/pmdcat#>.

  #     <http://gss-data.org.uk/data/gss_data/trade/ons-international-trade-in-services#scheme/itis-industry/dataset-catalog-record> a dcat:CatalogRecord;
  #     foaf:primaryTopic <http://gss-data.org.uk/data/gss_data/trade/ons-international-trade-in-services#scheme/itis-industry/dataset-catalog-entry>.

  #     <http://gss-data.org.uk/catalog/vocabularies> dcat:record <http://gss-data.org.uk/data/gss_data/trade/ons-international-trade-in-services#scheme/itis-industry/dataset-catalog-record>.

  #     <http://gss-data.org.uk/data/gss_data/trade/ons-international-trade-in-services#scheme/itis-industry/dataset-catalog-entry> a dcat:Dataset;
  #     pmdcat:datasetContents <http://gss-data.org.uk/data/gss_data/trade/ons-international-trade-in-services#scheme/itis-industry>.
  #     """

  Scenario: The `pmdify` can cope with description that are type markdown instead of string.
    Given the existing test-case files "dcatcli/*"
    When the pmdutils command CLI is run with "dcat pmdify 4g-coverage-v0-4-10.csv-metadata.json http://base-uri http://data-graph-uri http://catalog-metadata-graph-uri"
    Then the CLI should succeed
    And the file at "4g-coverage-v0-4-10.csv-metadata.json.nq" should exist
    Given the N-Quads contained in "4g-coverage-v0-4-10.csv-metadata.json.nq"
    Then the RDF should contain
      """
      @prefix pmdcat: <http://publishmydata.com/pmdcat#> .

      <http://base-uri/4g-coverage.csv#dataset-catalog-entry> a pmdcat:Dataset;
      pmdcat:markdownDescription "This dataset shows the percentage of geographic areas with 4G signal outdoors from at least 1 operator (signal threshold: 105dBm), in the UK, as of January 2024."^^<https://www.w3.org/ns/iana/media-types/text/markdown#Resource>.
      """