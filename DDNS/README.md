## DDNS Configuration on Centos 7

### Generate the HMAC-MD5 key
```
# dnssec-keygen -a hmac-md5 -b 128 -n USER dhcpupdate
# cat Kdhcpupdate*.key
```

### /etc/named.conf
```
options {
	listen-on port 53 { 127.0.0.1; 192.168.0.100; };
	listen-on-v6 port 53 { ::1; };
	directory 	"/var/named";
	dump-file 	"/var/named/data/cache_dump.db";
	statistics-file "/var/named/data/named_stats.txt";
	memstatistics-file "/var/named/data/named_mem_stats.txt";
	allow-query     { localhost; 192.168.0.0/24; };

	recursion yes;

	dnssec-enable yes;
	dnssec-validation yes;

	/* Path to ISC DLV key */
	bindkeys-file "/etc/named.iscdlv.key";

	managed-keys-directory "/var/named/dynamic";

	pid-file "/run/named/named.pid";
	session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
	type hint;
	file "named.ca";
};

acl "update-acl" {
	key dhcp_updater;
};

key dhcp_updater {
	algorithm HMAC-MD5;
	secret "kJXeaOPPGtoko0KKwTfCZg==";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
include "/etc/named.zones";
```

### /etc/named.zones
```
zone "example.com" IN {
	type master;
	file "master/example.com_fwd.zone";
	allow-update { "update-acl"; };
};

zone "0.168.192.in-addr.arpa" {
  	type master;
	file "master/example.com_rev.zone";
	allow-update { "update-acl"; };
};
```

### Create the zones diretory 
``` 
# mkdir /var/named/master
# chown named.named /var/named/master
```
### Forward & Reverse static zone files
```
# vim /var/named/master/example.com_fwd.zone
# vim /var/named/master/example.com_rev_zone

# chown -v named.named /var/named/master/example.com*
# restorecon -v /var/named/master/example.com*
```

### /etc/dhcp/dhcpd.conf
```
option domain-name "example.com";
option domain-name-servers 192.168.0.100;
default-lease-time 600;
max-lease-time 7200;

authoritative;

ddns-update-style interim;
update-static-leases on;

allow booting;
allow bootp;
allow unknown-clients;

log-facility local7;

key dhcp_updater {
  algorithm hmac-md5;
  secret kJXeaOPPGtoko0KKwTfCZg==;
}

zone 0.168.192.in-addr.arpa {
  primary 192.168.0.100;
  key dhcp_updater;
}

zone example.com {
  primary 192.168.0.100;
  key dhcp_updater;
}

subnet 192.168.0.0  netmask 255.255.255.0 {
  option broadcast-address 192.168.0.255;
  option routers 192.168.0.1;
  option domain-name "example.com";
  option domain-name-servers 192.168.0.100;

  # Known Client
  pool {
    range 192.168.0.1 192.168.0.50;
    deny unknown clients;
  }

  # Unknown machines
  pool {
    range 192.168.0.51 192.168.0.253;
    allow unknown clients;
    ddns-hostname = concat(binary-to-ascii(10, 8, "-", leased-address), "-wifi");
    ddns-domainname = "example.com";
  }
  next-server 192.168.0.100;
  filename "/pxelinux.0";
}

host jenkins {
  hardware ethernet 00:0c:29:3c:f5:a7;
  server-name "jenkins.example.com";
  fixed-address 192.168.0.130;
}
```
:+1: Congrat...
