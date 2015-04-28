#!/bin/bash
DIR=`dirname $0`

$DIR/kvm-mknod.sh
su user -c $DIR/menu.sh $1
