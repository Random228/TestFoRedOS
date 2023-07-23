#!/bin/bash
pwd=`pwd`
for list in `ls $pwd | grep rpm`; do
rpm2cpio $list | cpio -idmv
done
if [[ -n $list ]] then
rm -rf *rpm
fi