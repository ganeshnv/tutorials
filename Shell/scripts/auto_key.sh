#!/bin/bash

function make_script() {
	sed 'i/\[\[key\]\]/$1/g' remote_run.sh > remote_run_$2.sh 	
}

key="ajsdklfjaklsjdfkajsdlf jaksdjfklajsdfjaklsjdfklasjdfkljasdkfjklasdjflkasjdfkasjdfkajsf"

make_template $key $1

scp remote_run_$1.sh azjayaram@$2:~/

ssh azjayaram@$2 '/bin/bash ~/remote_run_$1.sh'
