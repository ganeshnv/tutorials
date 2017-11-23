Redis Installation on Centos-7.3
-------------------------------
`` # yum install epel-release ``
`` # yum install redis ``

Redis Configuration
--------------------
Default configuration : `` /etc/redis/redis.conf ``

Redis unique data:
------------------------

`` >SADD members value1 value1 . . . ``
`` >SMEMBER members ``
