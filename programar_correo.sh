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
  MPATH=$(dialog --inputbox "Path to email body text file: " 8 40 --output-fd 1)
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
  DAY=$(dialog --output-fd 1 --backtitle "Delivery Date" \
  --radiolist "Select delivery day:" 38 40 31 \
        1 1 on \
        2 2 off \
        3 3 off \
        4 4 off \
        5 5 off \
        6 6 off \
        7 7 off \
        8 8 off \
        9 9 off \
        10 10 off \
        11 11 off \
        12 12 off \
        13 13 off \
        14 14 off \
        15 15 off \
        16 16 off \
        17 17 off \
        18 18 off \
        19 19 off \
        20 20 off \
        21 21 off \
        22 22 off \
        23 23 off \
        24 24 off \
        25 25 off \
        26 26 off \
        27 27 off \
        28 28 off \
        29 29 off \
        30 30 off \
        31 31 off )
  null $DAY
done
CONT="no"
while [ "$CONT" != "yes" ] ; do 
  MONTH=$(dialog --output-fd 1 --backtitle "Delivery Date" \
  --radiolist "Select delivery month:" 19 40 12 \
        1 January on \
        2 February off \
        3 March off \
        4 April off \
        5 May off \
        6 June off \
        7 July off \
        8 August off \
        9 September off \
        10 October off \
        11 November off \
        12 December off )
  null $MONTH
done
CONT="no"
while [ "$CONT" != "yes" ] ; do 
  YEAR=$(dialog --output-fd 1 --backtitle "Delivery Date" \
  --radiolist "Select delivery year:" 9 40 2 \
        $CURRY Current on \
        $NEXTY Next off )
  null $YEAR
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
    APATH=$(dialog --inputbox "Path to attachment file: " 8 40 --output-fd 1)
    null $APATH
  done
fi


echo "VALUES: "
echo "Path: '$MPATH'"
echo "Sender's mail '$SMAIL'"
echo "Sender's name '$SNAME'"
echo "Destination mail '$DMAIL'"
echo "Email subject '$SUBJECT'"
echo "Delivery date (dd/mm/yyy): '$DAY/$MONTH/$YEAR'"
if [ "$ATTACH" == "yes" ] ; then
  echo "Attachment '$APATH'"
fi

EMAIL="\"$SNAME\" <$SMAIL>"
echo "Email: '$EMAIL'"
echo
if [ "$ATTACH" == "no" ] ; then
  mutt -s "$SUBJECT" $DMAIL < $MPATH | at 4:16 AM $DAY.$MONTH.$YEAR
else
  mutt -s "$SUBJECT" -a $APATH -- $DMAIL < $MPATH | at 4:19 AM $DAY.$MONTH.$YEAR
fi
