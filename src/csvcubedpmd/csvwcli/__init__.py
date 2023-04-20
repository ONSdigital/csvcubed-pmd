from pathlib import Path
import click

from csvcubedpmd.csvwcli import findwhere


@click.group("csvw")
def csvw_group():
    """
    Work with CSV-Ws.
    """
    pass


@csvw_group.command("find-where")
@click.option(
    "--inside",
    "-i",
    help="Directory in which to search for CSV-W Metadata Files",
    type=click.Path(exists=True, path_type=Path, file_okay=False, dir_okay=True),
    default=".",
    show_default=True,
    metavar="SEARCH_DIR",
)
@click.option(
    "--negate", "-n", help="Negate the result of running the ASK query.", is_flag=True
)
@click.argument(
    "ask_query",
    type=click.STRING,
    metavar="ASK_QUERY",
)
def _find_where(inside: Path, negate: bool, ask_query: str):
    """
    Find all CSV-W metadata files within a given directory which match an ASK query.
    """
    findwhere.find_where(inside, ask_query, negate)
