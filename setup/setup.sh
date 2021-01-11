#!/bin/bash

APP=coturn
GROUP=turnserver
USER=turnserver
HOME=/opt/$APP
SYSD=/etc/systemd/system
SERFILE=coturn.service

init() {
  egrep "^$GROUP" /etc/group >/dev/null
  if [[ $? -ne 0 ]]; then
    groupadd -r $GROUP
  fi

  egrep "^$USER" /etc/passwd >/dev/null
  if [[ $? -ne 0 ]]; then
    useradd -r -g $GROUP -s /usr/sbin/nologin -M $USER
  fi

  if [[ ! -d $HOME/var/run ]]; then
    mkdir $HOME/var/run
    chmod 755 $HOME/var/run
  fi

  if [[ ! -d $HOME/var/log ]]; then
    mkdir $HOME/var/log
    chmod 755 $HOME/var/log
  fi

  chown -R $GROUP:$USER $HOME

  if [[ ! -s $SYSD/$SERFILE ]]; then
    ln -s $HOME/setup/$SERFILE $SYSD/$SERFILE
    echo "($APP) create symlink: $SYSD/$SERFILE --> $HOME/setup/$SERFILE"
  fi
}

deinit() {
  egrep "^$USER" /etc/passwd >/dev/null
  if [[ $? -eq 0 ]]; then
    userdel $USER
  fi

  egrep "^$GROUP" /etc/group >/dev/null
  if [[ $? -eq 0 ]]; then
    groupdel $GROUP
  fi

  chown -R root:root $HOME

  if [[ -s $SYSD/$SERFILE ]]; then
    rm -rf $SYSD/$SERFILE
    echo "($APP) delete symlink: $SYSD/$SERFILE"
  fi
}

start() {
  pgrep -x turnserver >/dev/null
  if [[ $? != 0 ]]; then
    systemctl start $SERFILE
    echo "($APP) turnserver start!"
  fi
  show
}

stop() {
  pgrep -x turnserver >/dev/null
  if [[ $? == 0 ]]; then
    systemctl stop $SERFILE
	echo "($APP) turnserver stop!"
  fi
  show
}

show() {
  ps -ef | grep turnserver | grep -v 'grep'
}

case "$1" in
  init)
    init
    ;;
  deinit)
    deinit
    ;;
  start)
    start
    ;;
  stop)
    stop
    ;;
  show)
	show
	;;
  *)
    SCRIPTNAME="${0##*/}"
    echo "Usage: $SCRIPTNAME {init|deinit|start|stop|show}"
    exit 3
    ;;
esac

exit 0

# vim: syntax=sh ts=4 sw=4 sts=4 sr noet
