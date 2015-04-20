#!/bin/bash

while [ 1 -eq 1 ] ; do
   ANSWER=`Xdialog --no-cancel --stdout --no-tags --icon ~/moony-avatar-eyes-small.xpm --menubox "Select Action" 0 0 8 term "Launch Terminal" studio "Launch Android Studio" exit "Exit"`
  echo ANSWER: $ANSWER

  if [ "$ANSWER" == "term" ] ; then
      terminology&
  elif [ "$ANSWER" == "studio" ] ; then
      RUNNING=`ps -efwwwww|grep com.intellij.idea.Main|grep -v grep`
      echo studio running? $RUNNING
      if [ "$RUNNING" == "" ] ; then
          /usr/local/android*/bin/studio.sh&
      else
          Xdialog --icon ~/moony-avatar-eyes-small.xpm --msgbox "Android Studio is already running" 0 0
      fi
  elif [ "$ANSWER" == "exit" ] ; then
      exit
  fi
done
