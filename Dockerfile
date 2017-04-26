FROM centos:7

MAINTAINER Aleksandr Lykhouzov <lykhouzov@gmail.com>

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;\
yum -y update; \
yum -y install rsyslog rsyslog-elasticsearch;\
yum clean all;\
systemctl enable rsyslog;\
sed -i 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf; \
sed -i 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf; \
sed -i 's/#$ModLoad imtcp/$ModLoad imtcp/g' /etc/rsyslog.conf; \
sed -i 's/#$InputTCPServerRun 514/$InputTCPServerRun 514/g' /etc/rsyslog.conf;

EXPOSE 514

CMD ["/usr/sbin/init"]
