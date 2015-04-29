#!/bin/bash

TERMINAL_PROG=$1

if [ "$TERMINAL_PROG" == "" ] ; then
    echo Requires 1 argument: terminal program to use
    exit 1
fi

ICON=/usr/local/share/moony-avatar-eyes-small.xpm 

while [ 1 -eq 1 ] ; do
   ANSWER=`Xdialog --title Launcher --no-cancel --stdout --no-tags --icon $ICON --menubox "Select Action" 0 0 8 term "Launch Terminal" studio "Launch Android Studio" exit "Exit"`

  if [ "$ANSWER" == "term" ] ; then
      Xdialog --title Launcher --icon $ICON --infobox Starting... 0 0 1000&
      ${TERMINAL_PROG}&
      sleep 2
  elif [ "$ANSWER" == "studio" ] ; then
      RUNNING=`ps -efwwwww|grep com.intellij.idea.Main|grep AndroidStudio|grep -v grep`
      if [ "$RUNNING" == "" ] ; then
           Xdialog --title Launcher --icon $ICON --infobox Starting... 0 0 1000&
          /usr/local/android*/bin/studio.sh&
          sleep 2
      else
          Xdialog --title Launcher --icon $ICON --msgbox "Android Studio is already running" 0 0
      fi
  elif [ "$ANSWER" == "exit" ] ; then
      BASE=`basename $0`
      # we could check for lots of processes, but let's at least check for
      # any running terminals or Android Studio
      RUNNING_TERMS=`ps -efwwwwww|grep $TERMINAL_PROG|grep -v grep|grep -v $BASE|grep -v init.sh|wc|awk '{print $1}'`
      ANDROID_STUDIO_RUNNING=`ps -efwwwww|grep com.intellij.idea.Main|grep AndroidStudio|grep -v grep` 
      SHOW_WARNING=0
      WARNING="You have"
      if [ $RUNNING_TERMS -gt 0 ] ; then
          SHOW_WARNING=1
          WARNING="$WARNING $RUNNING_TERMS terminal window"
          if [ $RUNNING_TERMS -gt 1 ] ; then
              WARNING="${WARNING}s"
          fi
      fi
      if [ "$ANDROID_STUDIO_RUNNING" != "" ] ; then
          SHOW_WARNING=1
          if [ $RUNNING_TERMS -gt 0 ] ; then
              WARNING="$WARNING and"
          fi
          WARNING="$WARNING Android Studio"
      fi
      if [ $SHOW_WARNING -gt 0 ] ; then
          WARNING="$WARNING running.\nAre you sure want to exit?"
          Xdialog --title Launcher --stdout --icon $ICON --yesno "$WARNING" 0 0
          if [ $? -eq 0 ] ; then
              exit
          fi
      else
          # nothing running that we care about. just exit
          exit
      fi
  fi
done
