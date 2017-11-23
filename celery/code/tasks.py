#!/usr/bin/python

from celery import Celery
import paramiko
import redis
import time

app = Celery ('tasks', broker='amqp://localhost//', backend='redis://localhost')

@app.task(rate_limit='1/s')
def ssh_run(host, port, user, command):
	r = redis.StrictRedis()
	r.sismember('commands',command)
	if ( r.sismember('commands',command)):
		bufsize=-1
		client = paramiko.SSHClient()
		client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
		try:
			client.connect(hostname=host, port=port, key_filename='/root/.ssh/id_rsa.pub', banner_timeout=10)
			chan = client.get_transport().open_session()
			chan.settimeout(120)
			chan.set_combine_stderr(True)
			chan.get_pty()
			chan.exec_command(command)
		except NameError:
			return "SSH Exited"
		stdout = chan.makefile('r',bufsize)
		stdout_text = stdout.read()
		status = int(chan.recv_exit_status())
		client.close()
		return stdout_text, status
 	else:
		return "redis command %s set not defined" % (command), 1
