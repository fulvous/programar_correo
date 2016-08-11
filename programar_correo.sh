#!/bin/bash
#León Ramos 2016 @fulvous

CURRY=$(date +%Y)
NEXTY=$((CURRY+1))
BACK="<OK>=Next <Cancel>=Back CTRL+C=exit"
STEP="welcome"

function null {
  VALUE="$1"
  if [ -z "$VALUE" ] ; then
    dialog --pause "No value received or cancel button pressed" 10 30 2
    STEP="$PREV"
  else
    #echo "OK going to $NEXT" ; sleep 1
    STEP="$NEXT"
  fi
  CONT="yes"
}

function welcome {
  dialog --textbox welcome.txt 22 70
  STEP="path"
}

function path {
  PREV="welcome"
  NEXT="smail"
  CONT="no"
  while [ "$CONT" != "yes" ] ; do 
    MPATH=$(dialog --stdout --backtitle "$BACK" --title "Path to email body text file: " --fselect "" 8 40)
    null "$MPATH"
  done
}

function smail {
  PREV="path"
  NEXT="sname"
  CONT="no"
  while [ "$CONT" != "yes" ] ; do 
    SMAIL=$( dialog --stdout --backtitle "$BACK" --inputbox "Sender's email address: " 8 40 "$SMAIL" )
    null "$SMAIL"
  done
}

function sname {
  PREV="smail"
  NEXT="dmail"
  CONT="no"
  while [ "$CONT" != "yes" ] ; do 
    SNAME=$(dialog --stdout --backtitle "$BACK" --inputbox "Sender's name: " 8 40 "$SNAME" )
    null "$SNAME"
  done
}

function dmail {
  PREV="sname"
  NEXT="subject"
  CONT="no"
  while [ "$CONT" != "yes" ] ; do 
    DMAIL=$(dialog --stdout --backtitle "$BACK" --inputbox "Destination email: " 8 40 "$DMAIL" )
    null "$DMAIL"
  done
}

function subject {
  PREV="dmail"
  NEXT="dateb"
  CONT="no"
  while [ "$CONT" != "yes" ] ; do 
    SUBJECT=$(dialog --stdout --backtitle "$BACK" --inputbox "Email Subject: " 8 40 "$SUBJECT" )
    null "$SUBJECT"
  done
}

function dateb {
  PREV="subject"
  NEXT="timeb"
  CONT="no"
  while [ "$CONT" != "yes" ] ; do 
    DATE=$(dialog --stdout --backtitle "$BACK" --date-format %d.%m.%Y --calendar "Select delivery date" 0 0 "$DATE" )
    null "$DATE"
  done
}

function timeb {
  PREV="dateb"
  NEXT="attach"
  CONT="no"
  while [ "$CONT" != "yes" ] ; do 
    TIME=$(dialog --stdout --backtitle "$BACK" --time-format %H:%M --timebox "Select delivery time:" 0 0 )
    null "$TIME"
  done
}

function attach {
  PREV="time"
  NEXT="build"
  dialog --title "Attachment"  --yesno "Add attachment to e-mail?" 6 25
  if [ "$?" -eq "0" ] ; then
    ATTACH="yes"
  else
    ATTACH="no"
  fi
  
  if [ "$ATTACH" == "yes" ] ; then
    CONT="no"
    while [ "$CONT" != "yes" ] ; do 
      APATH=$(dialog --stdout --backtitle "$BACK" --title "Path to attachment file: " --fselect "" 8 40 "$APATH")
      null "$APATH"
    done
  fi
}

function build {
  echo "VALUES: "
  echo "Path: '$MPATH'"
  echo "Sender's mail '$SMAIL'"
  echo "Sender's name '$SNAME'"
  echo "Destination mail '$DMAIL'"
  echo "Email subject '$SUBJECT'"
  echo "Delivery date (hh:min dd/mm/yyy): '$TIME $DATE'"
  if [ "$ATTACH" == "yes" ] ; then
    echo "Attachment '$APATH'"
  fi
  
  export EMAIL="\"$SNAME\" <$SMAIL>"
  echo "Email: '$EMAIL'"
  echo
  if [ "$ATTACH" == "no" ] ; then
    echo "mutt -s \"$SUBJECT\" $DMAIL < $MPATH" | at $TIME $DATE
  else
    echo "mutt -s \"$SUBJECT\" -a $APATH -- $DMAIL < $MPATH" | at $TIME $DATE
  fi
  STEP="exit"
}

while [ true ] ; do
  eval ${STEP}
done
