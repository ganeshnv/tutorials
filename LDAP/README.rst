Installation:
-------------

`` #yum -y install openldap* migrationtools ``

`` # slappasswd ``

Edit the lines:

cd /etc/openldap/slapd.d/cn=config
vi olcDatabase={2}hdb.ldif

olcSuffix: dc=example,dc=com
olcRootDN: cn=Manager,dc=example,dc=com

olcRootPW: < Slapd Password >
olcTLSCertificateFile: /etc/pki/tls/certs/exmaple.com.pem
olcTLSCertificateKeyFile: /etc/pki/tls/certs/example.com.pem

vi olcDatabase={1}monitor.ldif
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external, cn=auth" read by dn.base="cn=Manager,dc=example,dc=com" read by * none

# slapd verification

# slaptest -u
56abba86 ldif_read_file: checksum error on "/etc/openldap/slapd.d/cn=config/olcDatabase={1}monitor.ldif"
56abba86 ldif_read_file: checksum error on "/etc/openldap/slapd.d/cn=config/olcDatabase={2}hdb.ldif"
config file testing succeeded

# systemctl start slapd
# systemctl enable slapd

# netstat -lt | grep ldap

# cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG

# chown -R ldap:ldap /var/lib/ldap/

#  ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
#  ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
#  ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif

generate self-sign cert:
------------------------

# openssl req -new -x509 -nodes -out /etc/pki/tls/certs/example.com.pem -keyout /etc/pki/tls/certs/example.com.pem -days 366
# ll /etc/pki/tls/certs/*.pem

# cd /usr/share/migrationtools/
# vi migrate_common.ph
	> $DEFAULT_MAIL_DOMAIN = "example.com";
	> $DEFAULT_BASE = "dc=example,dc=com";
	> $EXTENDED_SCHEMA = 1;

# vi /root/base.ldif

dn: dc=example,dc=com
objectClass: top
objectClass: dcObject
objectclass: organization
o: example com
dc: example

dn: cn=Manager,dc=example,dc=com
objectClass: organizationalRole
cn: Manager
description: Directory Manager

dn: ou=People,dc=example,dc=com
objectClass: organizationalUnit
ou: People

dn: ou=Group,dc=example,dc=com
objectClass: organizationalUnit
ou: Group


# useradd ldapuser1
# useradd ldapuser2
# echo "redhat" | passwd --stdin ldapuser1
# echo "redhat" | passwd --stdin ldapuser2

# grep ":10[0-9][0-9]" /etc/passwd > /root/passwd
# grep ":10[0-9][0-9]" /etc/group > /root/group

# ./migrate_passwd.pl /root/passwd /root/users.ldif
# ./migrate_group.pl /root/group /root/groups.ldif

# ldapadd -x -W -D "cn=Manager,dc=example,dc=com" -f /root/base.ldif
# ldapadd -x -W -D "cn=Manager,dc=example,dc=com" -f /root/users.ldif
# ldapadd -x -W -D "cn=Manager,dc=example,dc=com" -f /root/groups.ldif

# ldapsearch -x cn=ldapuser1 -b dc=example,dc=com
# ldapsearch -x -b 'dc=example,dc=com' '(objectclass=*)'

checksum Error Fix:
===================

1. tail -n +3 /etc/openldap/slapd.d/cn=config.ldif >test.ldif
2. yum install perl-Archive-Zip
3. crc32 test.ldif
4. Replace the second line of the file /etc/openldap/slapd.d/cn=config.ldif

NFS Home directory exports:
---------------------------

# vi /etc/exports
/home *(rw,sync)


# yum -y install rpcbind nfs-utils
# systemctl start rpcbind
# systemctl start nfs
# systemctl enable rpcbind
# systemctl enable nfs

# showmount -e

LDAP client: 
============

# yum install -y openldap-clients nss-pam-ldapd
# authconfig-tui
# getent passwd ldapuser1
