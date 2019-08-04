FROM ubuntu:18.04

MAINTAINER Jay Collett <jay@jaycollett.com>

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -q -y update
RUN apt-get -q -y -o "DPkg::Options::=--force-confold" -o "DPkg::Options::=--force-confdef" install apt-utils && rm /etc/dpkg/dpkg.cfg.d/excludes
RUN apt-get -q -y -o "DPkg::Options::=--force-confold" -o "DPkg::Options::=--force-confdef" install isc-dhcp-server man
RUN apt-get -q -y autoremove
RUN apt-get -q -y clean && rm -rf /var/lib/apt/lists/*

RUN rm /etc/dhcp/dhcpd.conf
COPY dhcpdconf/dhcpd.conf /etc/dhcp/dhcpd.conf
COPY run_dhcpd.sh /run_dhcpd.sh

RUN touch /var/lib/dhcp/dhcpd.leases
RUN chown -R dhcpd:dhcpd /var/lib/dhcp

EXPOSE 67/udp 67/tcp

#ENTRYPOINT ["/run_dhcpd.sh"]