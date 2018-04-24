#!/bin/sh

playbook () {
    echo "Starting ansible playbook..."
    ansible-playbook -i /app/ansible/hosts /app/ansible/site.yml -c local
    echo "Ansible playbook finished."
}

# Argument keywords
if [ "$1" = "mailpile" ];then
    playbook
    exec s6-svscan /app/s6/
fi 

exec "$@"
