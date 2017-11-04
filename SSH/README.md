### SSH configuration

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
# autossh -M 10984 -N -f -o "PubkeyAuthentication=yes" -o "PasswordAuthentication=no" -o "ServerAliveInterval=30" -o "ServerAliveCountMax=3" -i /root/.ssh/rsa_key.pem -R 8888:localhost:22 user@middle-server 
```

### Forward connection
![Forwarded Connection](https://i.stack.imgur.com/a28N8.png)