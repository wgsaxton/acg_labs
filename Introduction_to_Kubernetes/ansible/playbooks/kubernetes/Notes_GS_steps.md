# My personal notes after coming back to this project

## Running ansible
main way to run ansible from this folder
```
ansible-playbook -i ../../hosts -u ubuntu main_playbook.yml
```

## ansible.cfg file
Most is commented out, but note the 3 items not commented out to run the ansible-playbook command from within the ansible folder and still find the key used to login, the username used, and not check for the key.
```
private_key_file=~/.ssh/id_rsa000
remote_user=ubuntu
host_key_checking=False
``` 