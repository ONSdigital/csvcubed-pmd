#from pathlib import Path
import xml.etree.ElementTree as ET
from lxml import etree


def rm_broken_char(xml_file):
    # with open(xml_file) as xml:
    #     contents = xml.read()
    # parser = etree.XMLParser(recover=True) # recover from bad characters.
    # root = etree.fromstring(contents, parser=parser)
    # print(etree.tostring(root))
    tree = ET.parse(xml_file)
    root = tree.getroot()
    return (etree.tostring(root))

rm_broken_char('tests/test-cases/dcatcli/TESTS-dcatcommandline.xml')