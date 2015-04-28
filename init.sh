#!/bin/bash
DIR=`dirname $0`

$DIR/kvm-mknod.sh
su devuser -c "$DIR/menu.sh $1"
