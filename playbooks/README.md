# Notes #

1. These playbooks have only been tested on CentOS 7.  They may work on RHEL.  They won't work on other distros.
2. In order to install some of the tools, you need to add the epel-release and ius repos.  See [common/tasks/main.yml](,/common/tasks/main.yml).  This is because the CentOS and RHEL repos do not contain some the latest versions of tools we need. 
3. The plays are organized into what are called "roles".  Roles are very helpful to create re-usable Ansible plays. There is a command line tool called *ansible-galaxy* that comes with Ansible that helps you scaffold the directory structure and files for a role.  See [here](http://docs.ansible.com/ansible/playbooks_roles.html) for details.
4. You will see that there is a pattern of roles depending on other roles.  This enables us to compose playbooks from reusable roles.  However, this does make things a bit difficult to understand exactly what is happening at first.  However, start from the top and navigate through the dependencies.
4. Note, I have a *common* role.  These contains tasks that are "common" across all hosts.  Not sure if we should do this as pre-tasks but this seems to be a common (excuse the pun) pattern.

### Useful Commands
1. Get ansible facts for a given host.  This will retrieve detailed information about the target host machine. Useful to see what facts you can access from your playbooks.
```
ansible <host|group> -m setup
```
2. List all tasks tasks in a playbook in the order they will be executed.  This is very useful to quickly validate your playbook.  
```
ansible-playbook --list-tasks playbook_file.yml
```
3. Do a dry run of your play book without actually making changes to the hosts.  Instead, it will attempt to determine what state changes would occur if any.
```
ansible-playbook --check playbook_file.yml
```
4. Step interactively through the execution of you playbook. This is useful, if the outcome is not what you expect
```
ansible-playbook --step playbook_file.yml
```


