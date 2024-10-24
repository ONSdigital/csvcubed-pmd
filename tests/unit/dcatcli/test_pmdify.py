import datetime

import pytest
import rdflib
from rdflib import Graph
from rdflib.query import ResultRow

from csvcubeddevtools.helpers.file import get_test_cases_dir


from csvcubedpmd.dcatcli import pmdify
from csvcubedpmd.models.CsvCubedOutputType import CsvCubedOutputType

_TEST_CASES_DIR = get_test_cases_dir() / "dcatcli"


def test_extracting_metadata_dcat_dataset():
    """
    Test we can successfully extract the metadata from a `dcat:Dataset` inside a CSV-W generated with csvcubed version < 0.5.x.
    """
    csvw_graph = Graph()
    csvw_graph.parse(
        str(_TEST_CASES_DIR / "4g-coverage-v0-4-10.csv-metadata.json"),
        format="json-ld",
    )
    csvw_type = pmdify._get_csv_cubed_output_type(csvw_graph)
    existing_dcat_dataset = pmdify._get_catalog_entry_from_dcat_dataset(csvw_graph, csvw_type)

    assert existing_dcat_dataset is not None
    assert existing_dcat_dataset.title == '4G coverage'
    assert existing_dcat_dataset.label == '4G coverage'
    assert existing_dcat_dataset.issued == datetime.datetime(2023, 3, 31, 12, 10, 26, 937229)
    assert existing_dcat_dataset.modified == datetime.datetime(2024, 9, 23, 10, 30)
    assert existing_dcat_dataset.comment == 'Percentage of geographic areas with 4G signal outdoors from at least 1 operator (signal threshold: 105dBm), UK, as of January 2024.'
    assert (
        existing_dcat_dataset.markdown_description
        == 'This dataset shows the percentage of geographic areas with 4G signal outdoors from at least 1 operator (signal threshold: 105dBm), in the UK, as of January 2024.'
    )
    assert (
        existing_dcat_dataset.license
        == "http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/"
    )
    assert (
        existing_dcat_dataset.creator
        == 'https://www.gov.uk/government/organisations/ofcom'
    )
    assert (
        existing_dcat_dataset.publisher
        == 'https://www.gov.uk/government/organisations/office-for-national-statistics'
    )
    assert existing_dcat_dataset.themes == {'https://www.ons.gov.uk/businessindustryandtrade/itandinternetindustry'}
    assert existing_dcat_dataset.keywords == {'combined-authority', 'county', 'local-authority', 'subnational', 'region', 'broadband-mobile-coverage', 'connectivity'}
    assert existing_dcat_dataset.identifier == '4G coverage'

def test_extracting_metadata_dcat_distribution():
    """
    Test we can successfully extract the metadata from a `dcat:Distribution` inside a CSV-W.
    """
    csvw_graph = Graph()
    csvw_graph.parse(
        str(_TEST_CASES_DIR / "4g-coverage-v0-5-1.csv-metadata.json"),
        format="json-ld",
    )
    csvw_type = pmdify._get_csv_cubed_output_type(csvw_graph)

    existing_dcat_distribution = pmdify._get_catalog_entry_from_dcat_dataset(csvw_graph, csvw_type)

    assert existing_dcat_distribution is not None
    assert existing_dcat_distribution.title == '4G coverage'
    assert existing_dcat_distribution.label == '4G coverage'
    assert existing_dcat_distribution.issued == datetime.datetime(2023, 3, 31, 12, 10, 26, 937229)
    assert existing_dcat_distribution.modified == datetime.datetime(2024, 9, 23, 10, 30)
    assert existing_dcat_distribution.comment == 'Percentage of geographic areas with 4G signal outdoors from at least 1 operator (signal threshold: 105dBm), UK, as of January 2024.'
    assert (
        existing_dcat_distribution.markdown_description
        == 'This dataset shows the percentage of geographic areas with 4G signal outdoors from at least 1 operator (signal threshold: 105dBm), in the UK, as of January 2024.'
    )
    assert (
        existing_dcat_distribution.license
        == "http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/"
    )
    assert (
        existing_dcat_distribution.creator
        == 'https://www.gov.uk/government/organisations/ofcom'
    )
    assert (
        existing_dcat_distribution.publisher
        == 'https://www.gov.uk/government/organisations/office-for-national-statistics'
    )
    assert existing_dcat_distribution.themes == {'https://www.ons.gov.uk/businessindustryandtrade/itandinternetindustry'}
    assert existing_dcat_distribution.keywords == {'county', 'region', 'subnational', 'combined-authority', 'connectivity', 'local-authority', 'broadband-mobile-coverage'}
    assert existing_dcat_distribution.identifier == '4G coverage'


def test_delete_metadata_dcat_dataset():
    csvw_graph = Graph()
    csvw_graph.parse(
        str(_TEST_CASES_DIR / "4g-coverage-v0-4-10.csv-metadata.json"),
        format="json-ld",
    )
    csvw_type = pmdify._get_csv_cubed_output_type(csvw_graph)

    existing_dcat_dataset = pmdify._get_catalog_entry_from_dcat_dataset(csvw_graph, csvw_type)
    assert existing_dcat_dataset is not None

    pmdify._delete_existing_dcat_metadata(csvw_graph)

    with pytest.raises(Exception) as exception:
        thing = pmdify._get_catalog_entry_from_dcat_dataset(csvw_graph, csvw_type)
    assert str(exception.value) == "Expected 1 dcat:Dataset record, found 0"


def test_delete_metadata_dcat_distribution():
    csvw_graph = Graph()
    csvw_graph.parse(
        str(_TEST_CASES_DIR / "4g-coverage-v0-5-1.csv-metadata.json"),
        format="json-ld",
    )
    csvw_type = pmdify._get_csv_cubed_output_type(csvw_graph)

    existing_dcat_dataset = pmdify._get_catalog_entry_from_dcat_dataset(csvw_graph, csvw_type)
    assert existing_dcat_dataset is not None

    pmdify._delete_existing_dcat_metadata(csvw_graph)

    with pytest.raises(Exception) as exception:
        thing = pmdify._get_catalog_entry_from_dcat_dataset(csvw_graph, csvw_type)
    assert str(exception.value) == "Expected 1 dcat:Dataset record, found 0"


def test_delete_dcat_metadata_removes_legacy_code_list_items():
    csvw_graph = Graph()
    csvw_graph.parse(
        str(_TEST_CASES_DIR / "itis-industry.csv-metadata.json"),
        format="json-ld",
    )

    assert _get_num_catalog_records(csvw_graph) == 1
    assert _get_num_catalog_entries(csvw_graph) == 1

    pmdify._delete_existing_dcat_metadata(csvw_graph)

    assert _get_num_catalog_records(csvw_graph) == 0
    assert _get_num_catalog_entries(csvw_graph) == 0


def _get_num_catalog_entries(csvw_graph: rdflib.Graph) -> int:
    results = csvw_graph.query("""
      PREFIX dcat: <http://www.w3.org/ns/dcat#>

      SELECT (COUNT(DISTINCT ?catalogEntry) as ?numCatalogEntries) 
      WHERE {
        ?catalogEntry a dcat:Dataset.
      }
    """)
    assert len(results) == 1
    return int(list(results)[0]["numCatalogEntries"])


def _get_num_catalog_records(csvw_graph: rdflib.Graph) -> int:
    results = csvw_graph.query("""
      PREFIX dcat: <http://www.w3.org/ns/dcat#>

      SELECT (COUNT(DISTINCT ?catalogRecord) as ?numCatalogRecords) 
      WHERE {
        ?catalogRecord a dcat:CatalogRecord.
      }
    """)
    assert len(results) == 1
    return int(list(results)[0]["numCatalogRecords"])


def test_identification_of_csvcubed_output_type():
    # Test `qb:DataSet` can be correctly identified.
    csvw_graph = Graph()
    csvw_graph.parse(
        str(_TEST_CASES_DIR / "4g-coverage-v0-5-1.csv-metadata.json"),
        format="json-ld",
    )
    actual_output_type = pmdify._get_csv_cubed_output_type(csvw_graph)

    assert actual_output_type == CsvCubedOutputType.QbDataSet

    # Test `skos:ConceptScheme` can be correctly identified.
    csvw_graph = Graph()
    csvw_graph.parse(
        str(_TEST_CASES_DIR / "period.csv-metadata.json"),
        format="json-ld",
    )
    actual_output_type = pmdify._get_csv_cubed_output_type(csvw_graph)

    assert actual_output_type == CsvCubedOutputType.SkosConceptScheme

    # Test legacy manually defined `skos:ConceptScheme` can be correctly identified.
    csvw_graph = Graph()
    csvw_graph.parse(
        str(_TEST_CASES_DIR / "itis-industry.csv-metadata.json"),
        format="json-ld",
    )
    actual_output_type = pmdify._get_csv_cubed_output_type(csvw_graph)

    assert actual_output_type == CsvCubedOutputType.SkosConceptScheme


def test_catalog_uris_for_csvcubed_output_types():
    assert (
        pmdify._get_catalog_uri_to_add_to(CsvCubedOutputType.SkosConceptScheme)
        == "http://gss-data.org.uk/catalog/vocabularies"
    )
    assert (
        pmdify._get_catalog_uri_to_add_to(CsvCubedOutputType.QbDataSet)
        == "http://gss-data.org.uk/catalog/datasets"
    )



if __name__ == "__main__":
    pytest.main()
