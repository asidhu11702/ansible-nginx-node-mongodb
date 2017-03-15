# Deploying nginx, node, mongoDB using Ansible #

In this example, we build on top of the solution where we deployed Ansible to a Linux cluster using custom script extensions.  You can see that solution [here.](https://bitbucket.org/architech/azure-custom-script-extensions).  Note, going forward we will be using the CentOS distro as that is what we will be using for all projects.

Now that ssh authentication has been configured across the control and target hosts, we are now going to demonstrate the following:

1. setting up ssh authentication with Bitbucket.  This is required to checkout the playbooks and the node application we are going to deploy. 
2. use Ansible to configure nginx, node, and mongoDB on the target host machines.
3. Deploy the node app and run a simple test to demonstrate that everything is working ok.

In future sessions, we will hook up a CI pipeline to automatically deploy the node application to the linux cluster.

## How to deploy ##

For convenience, I have copied the arm templates and custom script extension from the [custom script extensions repo](https://bitbucket.org/architech/azure-custom-script-extensions).  I did modify them slightly to support CentOS.

1. First deploy the ARM templates.  See [here](https://bitbucket.org/architech/azure-custom-script-extensions) for instructions.
2. Set up ssh authenication with BitBucket.  Use the same public key that you use to deploy the ARM template.  This is very important or you will not be able to authenticate with Bitbucket. See [here](https://confluence.atlassian.com/bitbucket/set-up-ssh-for-git-728138079.html) for instructions.
2. Once the infra has been provisioned, log onto the jumpboxVm which will be our Ansible control machine.
3. start up ssh-agent and add the private key.  This is required for the appVms to be able to authenticate with BitBucket to clone the repo and start up the node app.  In the future, I will enhance the extension script to modify .bashrc to start up the ssh-agent and shut it down with each login/logout.

```
#start up ssh-agent
exec /usr/bin/ssh-agent $SHELL

#add the private key provisioned by the extension
ssh-add ~/.ssh/id_rsa

#list the keys added to verify that it is there.
ssh-add -l 
```
4. git will already be installed on all the host machines, pull the playbooks from Bitbucket.  
5. cd into playbooks directory and execute the following commands.

```
#this will list all the tasks that will be executed and verify the playbook
ansible-playbook --list-tasks configure_all.yml 

#this will execute the playbook against all hosts targeted in the playbook
ansible-playbook configure_all.yml --ask-sudo-pass
```

For more information see the [README](./playbooks/README.md) in the playbooks directory.

## DISCLAIMER ##

These are NOT production ready playbooks!!  There is lot more that needs to be done to make these production ready.  For example, mongoDB is using the default configuration which is not appropriate.  The purpose is to keep things simple so you can understand Ansible concepts.

## References ##

1. [Ansible documentation](http://docs.ansible.com/ansible/)
2. [Ansible Module Docs](https://docs.ansible.com/ansible/list_of_all_modules.html)
3. [Nginx Admin Guide](https://www.nginx.com/resources/admin-guide/)
4. [Installing Nginx on CentOS](https://www.nginx.com/resources/wiki/start/topics/tutorials/install/)
5. [Installing mongoDB on CentOS/Redhat](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/)
6. [Installing node on CentOS](https://tecadmin.net/install-latest-nodejs-and-npm-on-centos/#)
7. [Ansible Performance Tuning](https://www.ansible.com/blog/ansible-performance-tuning)