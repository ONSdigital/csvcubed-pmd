#from pathlib import Path
from xml.etree import ElementTree as et


def rm_broken_char(xml_file):
    # with open(xml_file) as xml:
    #     contents = xml.read()
    # parser = etree.XMLParser(recover=True) # recover from bad characters.
    # root = etree.fromstring(contents, parser=parser)
    # print(etree.tostring(root))

    # tree = ET.parse(xml_file)
    # root = tree.getroot()
    # return (etree.tostring(root))

    tree = et.parse(xml_file)
    tree.find('idinfo/timeperd/timeinfo/rngdates/begdate').text = '1/1/2011'
    tree.find('idinfo/timeperd/timeinfo/rngdates/enddate').text = '1/1/2011'
    tree.write(xml_file)

rm_broken_char('tests/test-cases/dcatcli/TESTS-dcatcommandline.xml')