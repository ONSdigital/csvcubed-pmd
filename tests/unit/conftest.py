import logging
import sys

import csvcubed.utils.log
import pytest


@pytest.fixture(autouse=True, scope="session")
def configure_logging():
    """Make sure to remove all the existing log files so we don't contaminate the tests."""
    root_logger = logging.getLogger("csvcubed-pmd")
    for filter in root_logger.filters:
        root_logger.removeFilter(filter)
    for handler in root_logger.handlers:
        root_logger.removeHandler(handler)

    handler = logging.StreamHandler(sys.stdout)
    handler.setLevel(logging.DEBUG)
    handler.setFormatter(
        logging.Formatter(f"%(asctime)s - %(name)s - %(levelname)s - %(message)s")
    )
    root_logger.addHandler(handler)

    csvcubed.utils.log.start_logging("pmdutils-csvcubed", logging.DEBUG)
