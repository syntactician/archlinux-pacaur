# archlinux-pacaur

An AUR-capable Docker image.

## Rationale

This image is inspired by [chrert](https://hub.docker.com/u/chrert)'s [docker-arch-yaourt](https://hub.docker.com/r/chrert/docker-arch-yaourt/) image.

It is intended to be used to manage dependencies from the AUR with [pacaur](https://github.com/rmarquis/pacaur) in an otherwise minimal Arch image.

## Details

This image is built atop [pritunl](https://hub.docker.com/u/pritunl)'s [archlinux](https://hub.docker.com/r/pritunl/archlinux/), and will be updated to match each release.

This image provides additionally a user `build` in the group `wheel`. `/etc/sudoers/` is configured such that users in `wheel` have `sudo` privileges without a password, allowing operations like `pacaur --noconfirm -S python-xlib` *just work* for `build`.

This user can also be used to build your own `PKGBUILD`s.  This image provides the directories `/build` and `/home/build` which belong to to `build`. `/home/build` exists only to contain `~/.gnupg` for `build`, so `PKGBUILD`s should be built in subdirectories of `/home/build`.

## Usage

Here's an example Dockerfile using this as a base image:

```{docker}
FROM syntactician/archlinux-pacaur
MAINTAINER Your Name

# act as build user
USER build

# install from AUR
RUN pacaur --noconfirm -S python-xlib

# build from a custom PKGBUILD via github
WORKDIR /build
RUN git clone https://github.com/your/git-package
WORKDIR /build/git-package
RUN makepkg --noconfirm -sri

# build from local PKGBUILD
COPY PKGBUILD /build/local-package/PKGBUILD
WORKDIR /build/local-package
RUN makepkg --noconfirm -sri

# remove build user
USER root
RUN userdel -r build && rm /home/build
```
