#!/bin/bash
#
#author junun
#This script for performance an new centos7
#epoll selinux limits
#
#

yum -y install epel-release

setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux

cat >> /etc/bashrc <<EOF
export HISTTIMEFORMAT="%Y-%m-%d-%H:%M:%S "
EOF

cat >> /etc/security/limits.conf <<EOF
* soft nofile 40960
* hard nofile 40960
EOF

cat > /usr/bin/safecron <<-'EOF'
#!/bin/bash
# remove -r function from crontab
# PATH

if [[ "$*" =~ "-r" ]] ; then
        echo "SB! Dangerous..."
        echo "Exit..."
        exit 2
else
        /usr/bin/crontab $*
        exit 0
fi
EOF

chmod +x /usr/bin/safecron
grep "crontab='/usr/bin/safecron'" /etc/bashrc || echo "alias crontab='/usr/bin/safecron'" >> /etc/bashrc

#(crontab -l 2>/dev/null; echo "0 * * * * /usr/sbin/ntpdate clock.isc.org &") | crontab -

chmod +x /etc/rc.d/rc.local
systemctl enable rc-local
systemctl start rc-local

#禁用firewalld
systemctl stop firewalld
systemctl disable firewalld

sysctl -p > /dev/null
