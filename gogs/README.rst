Gogs on Centos 7
=============================

yum repo
--------
* # wget -O /etc/yum.repos.d/gogs.repo https://dl.packager.io/srv/pkgr/gogs/pkgr/installer/el/7.repo
* # yum install gogs

# systemctl start gogs
# systemctl enable gogs

install Maria 10.2 ( working DB )
---------------------------------
vi /etc/yum.repos.d/mariadb.repo
::

[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.2/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1

# yum install MariaDB-server MariaDB-client

# mysqladmin -uroot password <dbpass>

# mysql -uroot -p

* create database gogs
* set global storage_engine=INNODB;

# systemctl start mariadb
# systemctl enable mariadb

install nginx
-------------

# yum install epel-release
# yum install nginx

vi /etc/nginx/nginx.conf

location / {
	proxy_pass http://localhost:6000;
}

# systemctl start nginx
# systemctl enable nginx

First time configuration
------------------------

http://gogs.example.com

LDAP configuration
------------------

1. Login as admin
2. Admin Panel -> Authentication
3. Add New Source 

	* Ldap Host : localhost 
	* Ldap Port : 389
	* Base DN: cn=Manager,dc=example,dc=com
	* Bind Password: < slapd pass >
	* User searches: ou=People,dc=example,dc=com
	* User Filter: (&(objectClass=posixAccount)(uid=%s))
	* Email Attr: mail
