#!/bin/bash
set -e
if [ -e /mtr_from_source_installed ];then
  echo "mtr_from_source_installed exists."
  exit 0
fi
cd /tmp
tar xf mtr.tar.gz
cd /tmp/mtr-*
./configure
make
make install
rm -rf /tmp/mtr*
touch /mtr_from_source_installed
