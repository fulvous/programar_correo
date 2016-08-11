#!/bin/bash

TEST=$(dialog --output-fd 1 --time-format %H:%M --timebox "Select delivery time:" 0 0  )
 echo "$TEST"
