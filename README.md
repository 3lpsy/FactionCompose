
### Firewalld

```
$ firewall-cmd --permanent --zone=trusted --add-interface=factionpub0
# probably optional
$ firewall-cmd --permanent --zone=trusted --add-interface=docker0 
```
