#!/bin/bash

function make_script() {
	eval key=$1
	sed "s/key_paste/$key/" remote_run.sh > remote_run_$2.sh
}
valid_check () {
	if [ $1 -eq 0 ]
	then
		return 0
	else
		return 1
	fi
}
key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBYDfhbwJXcR9RWr6A3A5/zOIOtxmvYnrwzjMzMfM7DRGdjFSOcePY1upTTotMFwK8QMx5hC+/zCjuQkp+z1WiSVC2eLWmEdEw5Rw8MFGZnTc2HF4Su/m7flB3JpRG/8jTTNmqd4Ru8qGvbGPPbgtdGtnIeNErUpH46EepXy6X4vJkZnTpBP/CiPFAg4rbmOVQIQuuyxtCZT3MTu49ot87N8THgBNDttjIa3J2ORTUGlMJmMjeO1ULxIorFtjtvMiD7KlnmJMqsWVJ0QFceI4uCKc5C3X58wU9bfGB1jWR2rTRWAanPYSNwONZb+oL1HApTzuB+2nRfbkC590iXpPV root@server.example.com"
echo $key > key_temp.txt
sed -i 's/\//\\\//g' key_temp.txt
key=`cat key_temp.txt`
rm -fv key_temp.txt
make_script "\${key}" $1
scp remote_run_$1.sh $2@$1:~/ && echo "script copied to $1 remote"
ssh $2@$1 "/bin/bash ~/remote_run_$1.sh"
valid_check $? && ssh $2@$1 "rm -fv ~/remote_run_$1.sh" && echo "remote temp script removed"
