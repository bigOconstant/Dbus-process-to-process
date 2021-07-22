#!/bin/bash

# Launch dbus got info on how here https://dbus.freedesktop.org/doc/dbus-launch.1.html
echo "starting dbus server "
## test for an existing bus daemon, just to be safe
  if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
      ## if not found, launch a new one
      eval `dbus-launch --sh-syntax`
      echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
  fi

echo "Write dbus address for use with client in the build folder"
env | grep DBUS_SESSION_BUS_ADDRESS | awk '{print "export " $0}' > .env ;


#/cppdbus/build/server

