#!/usr/bin/python3.7

# start a ldap instance to test this script:
# docker run --rm --name=main_ldap_1 --env LDAP_ADMIN_PASSWORD=admin howardlau1999/openldap-bcrypt

from docker import from_env as docker_env
import sys
import secrets
from string import digits, ascii_letters
from os import geteuid

_ldif = """
dn: uid={nickname},{department}
cn: {given_name} {lastname}
gidnumber: {uid}
givenname: {given_name}
homedirectory: /home/{nickname}
iphostnumber: 127.0.0.1
loginshell: /bin/false
objectclass: top
objectclass: shadowAccount
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: person
objectclass: ldapPublicKey
objectclass: posixAccount
objectclass: ipHost
sn: {lastname}
uid: {nickname}
uidnumber: {uid}
userpassword: {password}"""

_ldif_group_member = """
dn: {group}
changetype: modify
add: uniquemember
uniquemember: uid={nickname},{department}
"""


class Department:
    def __init__(self, name: str, dn: str, uid_range: range, member_of: list = []):
        self.name: str = name
        self.dn: str = dn
        self.uid_range: range = uid_range
        self.member_of: list = member_of

    def get_next_uid(self, occupied: list):
        for uid in self.uid_range:
            if uid in occupied:
                continue
            return uid


_departments = {
    "team": Department(
        name="Discord Team",
        dn="ou=discord-team,ou=people,dc=domain,dc=de",
        uid_range=range(1000, 1299),
        member_of=[
            "cn=nextcloud,ou=groups,dc=domain,dc=de",
            "cn=jitsi,ou=groups,dc=domain,dc=de",
        ],
    ),
    "external": Department(
        name="External",
        dn="ou=external,ou=people,dc=domain,dc=de",
        uid_range=range(5000, 5100),
        member_of=[
            "cn=jitsi,ou=groups,dc=domain,dc=de",
        ],
    ),
}


class Ldap:
    def __init__(self, container_name):
        self.container_name = container_name
        self.container = list(filter(
            lambda c: c.name == self.container_name,
            docker_env().containers.list()
        ))[0]
        self.ldap_password = list(filter(
            lambda x: x.split("=")[0] == 'LDAP_ADMIN_PASSWORD',
            self.container.attrs.get("Config").get("Env")
        ))[0].split("=")[1]

    def get_occupied_uids(self) -> list:
        raw_result = self.container.exec_run(
            f'ldapsearch -x -b ou=people,dc=domain,dc=de -D cn=admin,dc=domain,dc=de -w{self.ldap_password} uidNumber'
        ).output.decode().split("\n")
        return sorted(list(
            map(lambda x: int(x.split(": ")[1]), filter(lambda x: x.startswith("uidNumber"), raw_result))
        ))

    def generate_password(self, password: str) -> str:
        return self.container.exec_run(
            f"slappasswd -h '{{BCRYPT}}' -o module-load=/usr/lib/ldap/pw-bcrypt.so -s '{password}'"
        ).output.decode()

    def add_ldif(self, ldif: str):
        if input("Add to LDAP? [y/N]: ").lower() not in ['y', 'yes']:
            return

        self.container.exec_run(f"/bin/sh -c 'cat <<EOF > /tmp/adduser.ldif\n{ldif}\nEOF'")

        print(self.container.exec_run(
            f'ldapadd -x -D cn=admin,dc=domain,dc=de -w{self.ldap_password} -f /tmp/adduser.ldif'
        ).output.decode())

        self.container.exec_run("rm /tmp/adduser.ldif")

        print("Don't forget to adjust the groups!")
        return


def main():
    ldap = Ldap("main_ldap_1")

    given_name: str = sys.argv[1]
    lastname: str = sys.argv[2]
    nickname: str = sys.argv[3]
    _department: str = sys.argv[4]

    password: str = ""
    if len(sys.argv) > 5:
        password = sys.argv[5]
    else:
        chars = (digits + ascii_letters) * 3 + "-.:,~*+#"
        password = "".join(secrets.choice(chars) for _ in range(42))

    if _department not in _departments:
        print(f"Invalid Department: {_department}")
        print("Departments: ", list(_departments.keys()))
        exit(1)
    department: Department = _departments[_department]

    print("--------------------------------------------------------------")
    print(f"Firstname:\t{given_name}")
    print(f"Lastname:\t{lastname}")
    print(f"Nickname:\t{nickname}")
    print(f"Department:\t{department.name}")
    if len(sys.argv) < 5:
        print(f"Password:\t{password}")

    print("--------------------------------------------------------------")
    ldif = _ldif.format(
        lastname=lastname,
        given_name=given_name,
        uid=department.get_next_uid(ldap.get_occupied_uids()),
        nickname=nickname,
        department=department.dn,
        password=ldap.generate_password(password)
    )
    for group in department.member_of:
        ldif += _ldif_group_member.format(group=group, nickname=nickname, department=department.dn)

    print(ldif)
    print("--------------------------------------------------------------")

    ldap.add_ldif(_ldif)
    if department == _departments['external']:
        print("Please add a description to ldap object!")


if __name__ == '__main__':
    if geteuid() != 0:
        print("Please run the script as root!")
        exit(1)
    try:
        if len(sys.argv) < 5:
            print(f"Usage: {sys.argv[0]} firstname lastname nickname department [password]")
            exit(1)
        main()
    except KeyboardInterrupt:
        print("\nExiting...")
