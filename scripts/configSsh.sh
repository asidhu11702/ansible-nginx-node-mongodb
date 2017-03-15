#!/usr/bin/env bash

######################################################################################################
# Script Name: configSsh.sh 
# Author: Jungho Kim
# Description: Configures the VMs with ssh authentication on the control and target hosts so they can be configured by Ansible.
#  This version is only supported on CentOS distributions.
#
# Options:
# 
# -u <adminUserName>
# -k <sshPubKey>
# -t <control | target>         the type of the host
# -p <sshPrivateKey>            required if -t is control
#
# if -t is control then all are required
# if -t is target then only u, k are required 
#
# See the 'commandBase', 'controlHostCommand', 'targetHostCommand' variables in azureDeploy.json
#
#######################################################################################################

function log {
    echo "configSsh.sh --> $*"
}

function usage {
    log "Usage: IF -t is 'target' --> configSsh.sh -t target -u adminUserName -k sshPubKey"
    log "Usage: IF -t is 'control' --> configSsh.sh -t control -u adminUserName -k sshPubKey -p sshPubKey"  
}

function validate_parameters {
    # these must be provided regardless of the type of host
    if [ -z "$host_type" ] ;then log "-t must be provided"; usage; exit 1; fi
    if [ -z "$user" ] ;then log "-u must be provided"; usage; exit 1; fi 
    if [ -z "$public_key_file" ] ;then log "-k must be provided"; usage; exit 1; fi

    if [ "$host_type" == "control" ] 
    then
        if [ -z "$private_key_file" ] ;then log "-t was $host_type,  value for -p must be provided."; usage; exit 1; fi
    fi
}

function configure_ssh {
    if [ "$host_type" == "control" ]
    then
        configure_control_ssh
    else
        configure_target_ssh
    fi
}

function configure_target_ssh {
    if [ -f "$public_key_file" ] 
    then
        log "installing public key to /home/${user}/.ssh/authorized_keys"

        if [ ! -d /home/"${user}"/.ssh ]; then
            mkdir /home/"${user}"/.ssh
            chown -R "${user}":"${user}" /home/"${user}"/.ssh
        fi

        cat "$public_key_file" >> /home/"${user}"/.ssh/authorized_keys;
        rm "$public_key_file"
        chmod 700 /home/"${user}"/.ssh
        chmod 600 /home/"${user}"/.ssh/authorized_keys
        
        log "public key deployed"
    else
        log "$public_key_file was not found in the current directory.  exiting."
        exit 1
    fi
}


function configure_control_ssh {
    configure_target_ssh

    if [ -f "$private_key_file" ]
    then
        if [ ! -d /home/"${user}"/.ssh ]; then
            mkdir /home/"${user}"/.ssh
            chown -R "${user}":"${user}" /home/"${user}"/.ssh
        fi
        
        log "installing the private key to /home/${user}/.ssh/"
        
        cat "${private_key_file}" >> /home/"${user}"/.ssh/"${private_key_file}"
        chmod 700 /home/"${user}"/.ssh
        chmod 600 /home/"${user}"/.ssh/"${private_key_file}"

        log "installed the privated key."
    else
        log "$private_key_file was not found in the current directory.  exiting."
        exit 1
    fi
}

host_type=''
user=''
public_key_file=''
private_key_file=''

log "$# options and arguments were passed."

while getopts u:t:k:p:: opt; do
    case $opt in
        u)
            user=${OPTARG}
            log "user --> $user" 
            ;;
        t) 
            host_type=${OPTARG}
            log "host_type --> $host_type"
            ;;
        k)
            public_key_file=${OPTARG}
            log "public_key_file --> $public_key_file"
            ;;
        p) 
            private_key_file=${OPTARG}
            log "private_key_file --> $private_key_file"
            ;;
        \?) #invalid option
            log "${OPTARG} is not a valid option"
            usage
            exit 1
            ;;
    esac 
done

validate_parameters
configure_ssh

