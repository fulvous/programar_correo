#!/bin/bash

TEST=$(dialog --output-fd 1 --backtitle "Delivery Date" \
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
echo "TEST '$TEST'"
