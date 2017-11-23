#!/usr/bin/python

from tasks import * 
import sys

def on_raw_message(body):
	print(body)

host = sys.argv[1]
cmd = sys.argv[2]
r = ssh_run.apply_async([host, 22, 'root', cmd])
print(r.get(on_message=on_raw_message, propagate=False))

