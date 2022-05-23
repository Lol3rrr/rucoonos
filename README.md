# Rucoonos
A simple OS written in Rust that allows you to run a limited Number of Tasks

## Installation
You need to have the [rucoon runtime](https://github.com/Lol3rrr/rucoon) at the same root file directory as this because it is currently using a Path dependency for easier development

## Development
### Networking setup
To use the Tap networking in qemu, you need to setup a tap interface and brdige, such setup could look like this
```
brctl addbr br0
ip addr flush dev $INTERFACE
brctl addif br0 $INTERFACE
tunctl -t tap0 -u `whoami`
brctl addif br0 tap0
ifconfig $INTERFACE up
ifconfig tap0 up
ifconfig br0 up
dhclient -v br0
# Enable forwarding of broadcasts on the Bridge
echo 0 > /proc/sys/net/bridge/bridge-nf-call-iptables
```
