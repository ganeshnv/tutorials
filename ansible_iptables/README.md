### Adding New roles 

Add in begining tasks/main.yml
-----------------------------
	- name: set_facts
  	    set_fact:
              ipv4_static: "{{ ipv4_static }} + {{ ipv4_static_rules }}"

Assign the variable with ports in vars/main.yml
-----------------------------------------------

	---
	ipv4_static_rules:
  	   - "-A INPUT -s 192.168.1.1 -j ACCEPT"
  	   - "-A INPUT -p tcp -m state --state NEW -m tcp -m multiport --dports 80,443 -j ACCEPT"

Run playbook
------------
	`ansible-playbook iptables-playbook.yml --diff `
