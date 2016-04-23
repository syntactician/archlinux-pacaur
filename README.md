# archlinux-pacaur

An AUR-capable Docker image.

## Rationale

This image is inspired by [chrert](https://hub.docker.com/u/chrert)'s [docker-arch-yaourt](https://hub.docker.com/r/chrert/docker-arch-yaourt/) image.

It is intended to be used to manage dependencies from the AUR with [pacaur](https://github.com/rmarquis/pacaur) in an otherwise minimal Arch image.

## Details

This image is built atop [greyltc](https://hub.docker.com/u/greyltc)'s very transparent [archlinux](https://hub.docker.com/r/greyltc/archlinux/) image, and automatically builds to match each release.

This image provides additionally a user `build` in the group `wheel`. `/etc/sudoers/` is configured such that users in `wheel` have `sudo` privileges without a password, allowing operations like `pacaur --noconfirm -S python-flask-git` *just work* for `build`.

This user can also be used to build your own `PKGBUILD`s.  This image provides the directories `/build` and `/home/build` which belong to `build`. `/home/build` exists only to contain `~/.gnupg` for `build` (necessary for pacaur and some AUR packages), so `PKGBUILD`s should be built in subdirectories of `/build`. `$AURDEST` is also set to `/build`, so any packages installed via pacaur will have their source in `/build`. `$PACMAN` is set to `pacaur`, so `makepkg` will resolve `PKGBUILD` depends from the AUR using pacaur.

## Usage

Here's an example Dockerfile using this as a base image:

```{docker}
FROM syntactician/archlinux-pacaur
MAINTAINER Your Name

# install from AUR
su build -c 'pacaur --noconfirm -S python-flask-git'

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
