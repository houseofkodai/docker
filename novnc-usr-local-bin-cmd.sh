#!/bin/bash
# 25 JUN 2020: karthik@houseofkodai.in

#for non-bash uncomment the following
#trap "exit" INT TERM ERR

# kill background process on script exit
trap "kill 0" EXIT

export DISPLAY=:0
export TERM=st
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

/usr/bin/Xtigervnc -desktop "novnc" -SecurityTypes None -AlwaysShared -AcceptKeyEvents -AcceptPointerEvents -AcceptSetDesktopSize -SendCutText -AcceptCutText -depth 24 -geometry 640x480 -interface localhost -localhost -rfbport 5900 $DISPLAY 2>&1 1>/dev/null &
pid1=$!
status=$?
if [ $status -ne 0 ]; then
  echo "-err: Xtigervnc $status"
  exit $status
fi

/usr/local/bin/easy-novnc --no-url-password --novnc-params "resize=remote"  2>&1 1>/dev/null & 
pid2=$!
status=$?
if [ $status -ne 0 ]; then
  echo "-err: easy-novnc $status"
  exit $status
fi

#wait for Xtigervnc to be started - X$DISPLAY-lock is indicator that $DISPLAY is available
while [ ! -f /tmp/.X0-lock ]; do sleep 1; done

xsetroot -solid blue -name "novnc"
dwm &
pid3=$!
status=$?
if [ $status -ne 0 ]; then
  echo "-err: dwm $status"
  exit $status
fi

#if any process exits, exit all 
while sleep 2; do
  pidof easy-novnc 2>&1 1>/dev/null
  if [ $? -ne 0 ]; then exit 0; fi
  pidof Xtigervnc 2>&1 1>/dev/null
  if [ $? -ne 0 ]; then exit 0; fi
  pidof dwm 2>&1 1>/dev/null
  if [ $? -ne 0 ]; then exit 0; fi
done

# we dont get here, cause above - if any-exit, we exit 
#wait for all processes to exit 
#wait
