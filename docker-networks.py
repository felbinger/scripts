#!/usr/bin/python3.7

from docker import from_env as docker_env
from prettytable import PrettyTable


def get_networks():
    networks = list()
    for network in docker_env().networks.list():
        if network:
            config = network.attrs.get('IPAM').get('Config')
            subnet = config[0].get('Subnet') if len(config) else None
            if subnet:
                networks.append([
                    network.attrs.get('Name'),
                    subnet
                ])
    return networks


if __name__ == "__main__":
    networks = sorted(get_networks(), key=lambda ip: list(map(int, ip[1].split("/")[0].split("."))))

    table = PrettyTable()
    table.title = "Docker Networks"
    table.field_names = ["Name", "Subnet"]
    for row in networks:
        table.add_row(row)

    table.align['Name'] = 'l'
    table.align['Subnet'] = 'l'
    table.sortby = 'Subnet'
    print(table)
