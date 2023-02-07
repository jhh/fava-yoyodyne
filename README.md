# Gencon Beancount Fava Server

A NixOS server for sharing expenses over a Tailnet.

## Building

```
nix run github:nix-community/nixos-generators -- --format proxmox-lxc --flake .#container
```

Copy resulting .tar.xy file to LXC template dir, i.e.
`/mnt/pve/luna/template/cache` and create a container using the Proxmox admin
interface.

## Tailscale

For running in a Proxmox LXC, assign a static IP and add the following line to the config file:

```
# /etc/pve/lxc/<id>.conf
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
```
