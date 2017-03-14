# Deploying nginx, node, mongoDB using Ansible #

In this example, we build on top of the solution where we deployed Ansible to a Linux cluster using custom script extensions.  You can see that solution [here.](https://bitbucket.org/architech/azure-custom-script-extensions).  Note, going forward we will be using the CentOS distro as that is what we will be using for all projects.

Now that ssh authentication has been configured across the control and target hosts, we are now going to demonstrate the following:

1. setting up ssh authentication with Bitbucket.  This is required to checkout the playbooks and the node application we are going to deploy. 
2. use Ansible to configure nginx, node, and mongoDB on the target host machines.
3. Deploy the node app and run a simple test to demonstrate that everything is working ok.

In future sessions, we will hook up a CI pipeline to automatically deploy the node application to the linux cluster.

## How to deploy ##

For convenience, I have copied the arm templates and custom script extension from the [custom script extensions repo](https://bitbucket.org/architech/azure-custom-script-extensions).  I did modify them slightly to support CentOS, and as the Azure CentOS distro already comes with Ansible installed, there is no need to install it. 

1. First deploy the ARM templates.  See [here](https://bitbucket.org/architech/azure-custom-script-extensions) for instructions.
2. Set up ssh authenication with BitBucket.  Use the same public key that you use to deploy the ARM template.  This is very important or you will not be able to authenticate with Bitbucket. See [here](https://confluence.atlassian.com/bitbucket/set-up-ssh-for-git-728138079.html) for instructions.
2. Once the infra has been provisioned, log onto the jumpboxVm which will be our Ansible control machine.
3. git will already be installed on all the host machines, and the playbooks will have been pulled from Bitbucket.
4. cd into playbooks 

## DISCLAIMER ##

These are NOT production ready playbooks!!  There is lot more that needs to be done to make these production ready.  For example, mongoDB is using the default configuration which is not appropriate.  The purpose is to keep things simple so you can understand Ansible concepts.

## References ##

1. [Ansible documentation](http://docs.ansible.com/ansible/)
2. [Ansible Module Docs](https://docs.ansible.com/ansible/list_of_all_modules.html)
3. [Nginx Admin Guide](https://www.nginx.com/resources/admin-guide/)
4. [Installing Nginx on CentOS](https://www.nginx.com/resources/wiki/start/topics/tutorials/install/)
5. [Installing mongoDB on CentOS/Redhat](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/)
6. [Installing node on CentOS](https://tecadmin.net/install-latest-nodejs-and-npm-on-centos/#)