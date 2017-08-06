# func - fun with containers

Tools to build ports in containers:

  - create - create a chroot starting from the CRUX ISO hosted on the CRUX mirrors
  - configure - (re)configure a previously created container
  - upgrade - upgrade a container
  - clean - clean-up a container
  - pack - pack a container (for docker and al.)
  - clone - create a temporary container
  - chroot - run a command in a container
  - pkgmk - mount pkgmk directories in a container
  - ports - mount ports directories in a container
  - ccache - mount the ccache directory in a container
  - oprt - mount oprt settings directory in a container
  - prt-get - adapt /etc/prt-get.conf in a container

See func(1) or [func.1.pod](src/func.1.pod) for more info.

# System builds/upgrades

```
     Real system                         Temporary on-the-fly container
 ------------------    copy on write     -------------------------------
| /                | -----------------> | /                             |
|                  |                    |                               |
| /var/cache:      |      mounted       |                               |
|    src,pkg,build | -----------------> |                               |
|    ccache        |                    |                               |
|                  |                    |                               |
|                  |                    | prt-get sysup                 |
|                  |                    | ... Download src/port.version |
|                  |                    | ... Building pkg/port#version |
|                  |                    |                               |
|                /var/cache/src/port.version                            |
|                /var/cache/pkg/port#version                            |
|                  |                    |                               |
|                  |                     -------------------------------
|                   --------------
| prt-get sysup                   |
| ... Installing pkg/port#version |
 ---------------------------------
```

# Contained port builds

```
  chroot with
  core packages                               Temporary on-the-fly container
 -------------------    copy on write         ------------------------------
| /bin/...          | ---------------------> |                              |
| /lib/...          |                        |                              |
| /usr/...          |                        |                              |
 -------------------                         |                              |
                                             |                              |
   Real system                               |                              |
 -------------------                         |                              |
| /etc/ports        |      mount (ro)        |                              |
| /usr/ports        | ---------------------> |                              |
|                   |                        |                              |
|                   | copy + prtdir /home/u  |                              |
| /etc/prt-get.conf | ---------------------> | /etc/prt-get.conf            |
|                   |                        |                              |
|                   |      mount (rw)        |                              |
| ~/myport          | ---------------------> | /home/u/myport               |
|    Pkgfile        |                        |                              |
 -------------------                         |                              |
         |                                   |   prt-get depinst myport     |
         |                                    ------------------------------
         V

  ~/myport
    Pkgfile
    .footprint
    .md5sum

```

# TODO

  - document: src,pkg,work dirs has to be on the same partition as the cloned root (if symlinks and namespaces are used)
  - non-root user alternatives for: create, configure, upgrade, clean, pack (maybe using fakeroot -i load-file -s save-file, or with a proot archive)
  - chroot-docker
  - chroot-fakechroot
  - chroot-container
  - chroot-bubblewrap
