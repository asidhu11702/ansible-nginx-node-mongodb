# nginx on centOS

Since CentOS 6.6, the SELinux security permissions that apply to nginx is much more restrictive.  

If you see a '502 Bad Gateway' message when trying to connect to the port on which nginx is listening, and your upstream service is running, do the following:

```
sudo tail -f /var/log/nginx/error.log
```

If you see the following error message in the log, then this is a SELinux permission issue.

```
...connect() to 127.0.0.1:8080 failed (13: Permission denied) while connecting to upstream...
```

Run the following command to determine the root cause and corrective action:
```
sudo cat /var/log/audit/audit.log | grep nginx | grep denied | audit2why -w
```
The audit record, with root cause and correction action will be displayed.

```
type=AVC msg=audit(1489456753.570:2053): avc:  denied  { name_connect } for  pid=17717 comm="nginx" dest=8080 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:http_cache_port_t:s0 tclass=tcp_socket

	Was caused by:
	One of the following booleans was set incorrectly.
	Description:
	Allow httpd to can network connect

	Allow access by executing:
	# setsebool -P httpd_can_network_connect 1
	Description:
	Allow httpd to can network relay
    ...
```
In this case, the action to take is:
```
sudo setsebool -P httpd_can_network_connect 1
```
Within Ansible, there is a module that sets SELinux bits.  See [nginx/tasks/main.yml](./tasks/main.yml)

## References

1. [NGINX: SELinux Changes when Upgrading to RHEL 6.6 / CentOS 6.6](https://www.nginx.com/blog/nginx-se-linux-changes-upgrading-rhel-6-6/)
