blocked
======

Collect domains which is blocked at 23.0389686,113.3942843

### Resources

* [GreatFire.org](https://zh.greatfire.org/analyzer)
* [gfwlist](https://github.com/gfwlist/gfwlist)
* [wongsyrone/domain-block-list](https://github.com/wongsyrone/domain-block-list)
* [Leask/BRICKS](https://github.com/Leask/BRICKS)

### Usage

```
make PROXY="PROXY 127.0.0.1:1080"
make PROXY="socks5 127.0.0.1:8964; socks 127.0.0.1:8964"
make IPSET_NAME=gfwlist
```

