# Notes

## Unifi BGP Setup

```
configure
set protocols bgp 64501 parameters router-id 172.16.10.1
set protocols bgp 64501 neighbor 172.16.10.5 remote-as 64500
set protocols bgp 64501 neighbor 172.16.10.6 remote-as 64500
set protocols bgp 64501 neighbor 172.16.10.11 remote-as 64500
commit
save
exit
```

