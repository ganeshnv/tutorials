Rabbitmq installation
---------------------

`` # yum install epel-release ``
`` # yum install rabbitmq-server ``

Rabbitmq Channel & Queue maintance
----------------------------------

`` # rabbitmqctl list_channels ``
`` # rabbitmqctl list_queues ``
`` # rabbitmqctl list_queues consumers messages messages_ready messages_unacknowledged ``

Reset the state:
---------------

`` # rabbitmqctl stop_app ``
`` # rabbitmqctl reset ``
`` # rabbitmqctl start_app ``
