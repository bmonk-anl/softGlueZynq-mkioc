#!/bin/csh
set target=`/APSshare/bin/alivedb -p linux:hostname $1`
ssh vw5@$target telnet localhost 20000
