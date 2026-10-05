#!/bin/env python
"""
Connect with procServ instance started, for example, with the following command:
procServ -n microzed-j --logfile=procServ.log --noautorestart -i ^D^C 20000 ./run
"""

import commands
import os
import sys

usage = """
usage:
    procClient.py iocname
"""

def main():
	#print "sys.arvg:", sys.argv
	foundIt = False
	if len(sys.argv) == 2:
		ioc = sys.argv[1]
		target = commands.getoutput("/APSshare/bin/alivedb -p linux:hostname %s" % (ioc))
		if target != "":
			foundIt = True
			os.system("ssh vw5@%s telnet localhost 20000" % target)
		if not foundIt:
			print "Can't find %s in /APSshare/bin/alivedb" % ioc
	else:
		print (usage)
		return
if __name__ == "__main__":
	main()
