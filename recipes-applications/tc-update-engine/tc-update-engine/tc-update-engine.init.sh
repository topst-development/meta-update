#! /bin/sh
### BEGIN INIT INFO
# Provides:             Telechips Update Engine
# Required-Start:
# Required-Stop:
# Default-Start:        2 5
# Default-Stop:         0
# Short-Description:    Telechips Update Engine
# Description:
### END INIT INFO
#
# -*- coding: utf-8 -*-
# Debian init.d script for Telechips Launcher
# Copyright © 2014 Wily Taekhyun Shin <thshin@telechips.com>

# Source function library.
. /etc/init.d/functions

# /etc/init.d/micom-manager: start and stop the micom-manager daemon

DAEMON=/usr/bin/TcUpdateEngine
RUNDIR=/run/update-engine
ARGUMENTS="-c main"
DESC="telechips update engine"

test -x $DAEMON || exit 0

[ -r /etc/default/tc-update ] && . "/etc/default/tc-update"
[ -z "$SYSCONFDIR" ] && SYSCONFDIR=/var/lib/update-enagine
mkdir -p $SYSCONFDIR

check_for_no_start() {
    if [ -e $SYSCONFDIR/update-engine_not_to_be_run ]; then
	echo "update engine  not in use ($SYSCONFDIR/update-engine_not_to_be_run)"
	exit 0
    fi
}

check_privsep_dir() {
    # Create the PrivSep empty dir if necessary
    if [ ! -d /run/update-engine ]; then
		mkdir -p $RUNDIR
    fi
}

case "$1" in
  start)
	check_for_no_start
  	echo -n "Starting $DESC: "
	check_privsep_dir
	$DAEMON $ARGUMENTS &
  	echo "done."
	;;
  stop)
  	echo -n "Stopping $DESC: "
	/usr/bin/killall $DAEMON
  	echo "done."
	;;

  restart)
  	echo -n "Restarting $DESC: "
	/usr/bin/killall  $DAEMON
	check_for_no_start
	check_privsep_dir
	sleep 2
	$DAEMON $ARGUMENTS
	echo "."
	;;

  status)
	status $DAEMON
	exit $?
  ;;

  *)
	echo "Usage: /etc/init.d/micom-manager {start|stop|status|restart}"
	exit 1
esac

exit 0

