FROM pritunl/archlinux:latest
MAINTAINER Edward Hernandez

RUN pacman --noconfirm -S  \
		base-devel \
		git        \
		sudo

RUN sed -i '/NOPASSWD/s/\#//' /etc/sudoers
RUN useradd -r -g wheel build

WORKDIR /build
RUN chown -R build /build

WORKDIR /home/build
RUN chown -R build /home/build
USER build
RUN gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53

WORKDIR /build
RUN git clone https://aur.archlinux.org/cower.git
WORKDIR /build/cower
RUN makepkg --noconfirm -si

WORKDIR /build
RUN git clone https://aur.archlinux.org/pacaur.git
WORKDIR /build/pacaur
RUN makepkg --noconfirm -si
