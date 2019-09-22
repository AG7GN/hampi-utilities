#!/bin/bash

VERSION="1.0.0"

# This script checks the status of 4 GPIO pins and runs a script corresponding
# to those settings as described below.  This script is called by initialize-pi.sh,
# which is run a bootup via cron @reboot.

GPIO="$(command -v gpio) -g"

# Array P: Array index is the ID of each individual switch in the piano switch.
#          Array element value is the GPIO BCM number.
P[1]=25
P[2]=13
P[3]=6
P[4]=5

# String $PIANO will identify which levers are in the DOWN position 
PIANO=""
for I in 1 2 3 4
do
	J=$($GPIO read ${P[$I]}) # State of a switch in the piano (0 or 1)
	(( $J == 0 )) && PIANO="$PIANO$I"
done

# Check if the script corresponding to the piano switch setting exists and is not empty.
#
# Scripts must be in the $HOME directory, be marked as executable, and be named
# pianoX.sh where X is one of these:
# 1,12,13,14,123,124,134,1234,2,23,234,24,3,34,4
#
# Example:  When the piano switch levers 2 and 4 are down, the script named 
#           $HOME/piano24.sh will run whenever the Raspberry Pi starts.
#echo "running piano$PIANO.sh"
[ -s $HOME/piano$PIANO.sh ] && $HOME/piano$PIANO.sh

