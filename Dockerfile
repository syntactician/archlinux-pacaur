FROM pritunl/archlinux:latest
MAINTAINER Edward Hernandez

RUN pacman --noconfirm -Syyuu
RUN pacman --noconfirm -S  \
		base-devel \
		git        \
		sudo

RUN sed -i '/NOPASSWD/s/\#//' /etc/sudoers
RUN useradd -r -g wheel pacaur

WORKDIR /tmp/build
RUN chown -R pacaur /tmp/build

WORKDIR /home/pacaur
RUN chown -R pacaur /home/pacaur
USER pacaur
RUN gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53

WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/cower.git
WORKDIR /tmp/build/cower
RUN makepkg --noconfirm -si

WORKDIR /tmp/build
RUN git clone https://aur.archlinux.org/pacaur.git
WORKDIR /tmp/build/pacaur
RUN makepkg --noconfirm -si
