#!/usr/bin/env bash

exec /usr/bin/ssh-agent $SHELL

#add the private key provisioned by the extension
ssh-add ~/.ssh/id_rsa

#list the keys added to verify that it is there.
echo ssh-add -l 