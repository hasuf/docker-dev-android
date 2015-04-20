#!/bin/bash


ICON=/usr/local/share/moony-avatar-eyes-small.xpm 

while [ 1 -eq 1 ] ; do
   ANSWER=`Xdialog --no-cancel --stdout --no-tags --icon $ICON --menubox "Select Action" 0 0 8 term "Launch Terminal" studio "Launch Android Studio" exit "Exit"`

  if [ "$ANSWER" == "term" ] ; then
      terminology&
  elif [ "$ANSWER" == "studio" ] ; then
      RUNNING=`ps -efwwwww|grep com.intellij.idea.Main|grep AndroidStudio|grep -v grep`
      if [ "$RUNNING" == "" ] ; then
          /usr/local/android*/bin/studio.sh&
      else
          Xdialog --icon $ICON --msgbox "Android Studio is already running" 0 0
      fi
  elif [ "$ANSWER" == "exit" ] ; then
      exit
  fi
done
