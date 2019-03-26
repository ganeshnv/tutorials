# SSH configuration

### Use Proxy to Remote Server
```
# ssh -D 50000 user@ssh_server

Proxy Config: localhost:50000
```

### Reverse SSH connection 

```
# ssh -R 11121:localhost:22 user@middle-server
```

### Reverse SSH background mode
```
# ssh -f -N -T -R 8888:localhost:22 user@middle-server
```

### Switch to Restricted Network Host
```
# ssh -f -N -T -R 8888:restrictedhost.example.com:22 user@middleman
```

### Reconnect using autossh tools
```
# yum install autossh 
# vim /etc/rc.local
  autossh -M 10984 -N -f -o "PubkeyAuthentication=yes" -o "PasswordAuthentication=no" -o "ServerAliveInterval=30" -o "ServerAliveCountMax=3" -i /root/.ssh/rsa_key.pem -R 8888:localhost:22 user@middle-server 
```

### autossh useful link
https://www.everythingcli.org/ssh-tunnelling-for-fun-and-profit-autossh/


### Reverse Connection
![Reverse Connection](http://newgatewaysolution.com/images/personal/4iK3b.png)

### Forward Connection
![Forwarded Connection](http://newgatewaysolution.com/images/personal/a28N8.png)
