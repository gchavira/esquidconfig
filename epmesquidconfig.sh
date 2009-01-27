#!/usr/bin/env bash

cd /opt

/bin/rm -rf /opt/esquidconfig
/bin/rm -f /opt/linux-2.6-intel/esquidconfig-8.7.23-linux-2.6-intel.rpm

git clone ssh://root@e-electrosystems.com/git/esquidconfig.git /opt/esquidconfig

find /opt/esquidconfig | awk '/.*\.svn.*/ { print "/bin/rm -rf " $0 }' | bash -x

/bin/rm -f /opt/esquidconfig.list*

echo "%product esquidconfig" >> /opt/esquidconfig.list
echo "%copyright 2008 by ElectroSystems" >> /opt/esquidconfig.list
echo "%vendor ElectroSystems S. de R.L. de C.V." >> /opt/esquidconfig.list
echo "%description eSQUIDConfig Web Based SQUID Configuration" >> /opt/esquidconfig.list
echo "%version 8.7.23" >> /opt/esquidconfig.list
echo "%readme README" >> /opt/esquidconfig.list
echo "%license LICENSE" >> /opt/esquidconfig.list
echo "%packager Gabriel Medina" >> /opt/esquidconfig.list

mkepmlist /opt/esquidconfig >> /opt/esquidconfig.list

cd /opt
epm -f rpm -n esquidconfig

mv /opt/linux-2.6-intel/esquidconfig-8.7.23.rpm /opt

/bin/rm -rf /opt/linux-2.6-intel
/bin/rm -rf /opt/esquidconfig
/bin/rm -rf /opt/esquidconfig.list*






