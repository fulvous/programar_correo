#!/bin/bash
#León Ramos 2016 @fulvous

CONT="no"
CURRY=$(date +%Y)
NEXTY=$((CURRY+1))

function quit {
  dialog --title "Exit process"  --yesno "Are you sure?" 6 25 --output-fd 1
  if [ "$?" -eq "0" ] ; then
    exit 0
  fi
}

function null {
  if [ -z "$1" ] ; then
    quit
    CONT="no"
  else
    CONT="yes"
  fi
}


dialog --textbox welcome.txt 22 70

while [ "$CONT" != "yes" ] ; do 
  MPATH=$(dialog --title "Path to email body text file: " --fselect "" 8 40 --output-fd 1)
  null $MPATH
done
CONT="no"
while [ "$CONT" != "yes" ] ; do 
  SMAIL=$( dialog --inputbox "Sender's email address: " 8 40 --output-fd 1 )
  null $SMAIL
done
CONT="no"
while [ "$CONT" != "yes" ] ; do 
  SNAME=$(dialog --inputbox "Sender's name: " 8 40 --output-fd 1)
  null $SNAME
done
CONT="no"
while [ "$CONT" != "yes" ] ; do 
  DMAIL=$(dialog --inputbox "Destination email: " 8 40 --output-fd 1)
  null $DMAIL
done
CONT="no"
while [ "$CONT" != "yes" ] ; do 
  SUBJECT=$(dialog --inputbox "Email Subject: " 8 40 --output-fd 1)
  null $SUBJECT
done
CONT="no"
while [ "$CONT" != "yes" ] ; do 
  DATE=$(dialog --output-fd 1 --date-format %d.%m.%Y --calendar "Select delivery     date" 0 0)
  null $DATE
done
CONT="no"
while [ "$CONT" != "yes" ] ; do 
  TIME=$(dialog --output-fd 1 --time-format %H:%M --timebox "Select delivery time:" 0 0 )
  null $TIME
done


dialog --title "Attachment"  --yesno "Add attachment to e-mail?" 6 25
if [ "$?" -eq "0" ] ; then
  ATTACH="yes"
else
  ATTACH="no"
fi

if [ "$ATTACH" == "yes" ] ; then
  CONT="no"
  while [ "$CONT" != "yes" ] ; do 
    APATH=$(dialog --title "Path to attachment file: " --fselect "" 8 40 --output-fd 1)
    null $APATH
  done
fi


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

EMAIL="\"$SNAME\" <$SMAIL>"
echo "Email: '$EMAIL'"
echo
if [ "$ATTACH" == "no" ] ; then
  echo "mutt -s \"$SUBJECT\" $DMAIL < $MPATH" | at $TIME $DATE
else
  echo "mutt -s \"$SUBJECT\" -a $APATH -- $DMAIL < $MPATH" | at $TIME $DATE
fi
