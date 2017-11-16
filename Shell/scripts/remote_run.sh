#!/bin/bash
if [ -d ~/.ssh ]
then
	echo ".ssh file exist"
else
	mkdir -v ~/.ssh
	chmod 700 ~/.ssh
fi
echo "Paste the key"
key="key_paste"
echo "$key" >> ~/.ssh/authorized_keys && echo "Authorized Key Pasted"
chmod 600 ~/.ssh/authorized_keys && echo "permission given Authorized_keys"
