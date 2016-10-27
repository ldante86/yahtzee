#!/bin/echo This file is a part of yahtzee

# Location and player information
PROGRAM="${0##*/}"		# Name of game
SCORE_DIR=~/.yahtzee		# Score directory
SCORE_FILE=yahtzee-scores	# Score file
PLAYER=$(whoami)		# Player's name

# Sections
ONES="-"			# Upper section variables
TWOS="-"
THREES="-"
FOURS="-"
FIVES="-"
SIXES="-"
FULL_HOUSE="-"			# Lower section variables
SMALL_STRAIGHT="-"
LARGE_STRAIGHT="-"
THREE_OF_A_KIND="-"
FOUR_OF_A_KIND="-"
YAHTZEE="-"
CHANCE="-"
BONUS="-"

# Score counters
UPPER_TOTAL=0			# Upper section total
GRAND_TOTAL=0			# Total score
UPPER=0				# Upper section complete: 1=yes 0=no

# Fixed scores
FH_SCORE=25			# Full house score
SS_SCORE=30			# Small straight score
LS_SCORE=40			# Large straight score
YAHTZEE_BONUS=50		# Bonus for yahtzee
GRANT_BONUS=63			# Minimum upper score to get bonus
UPPER_BONUS=35			# Upper bonus value

# Terminal modifiers
BO=$(tput bold)			# Bold on
LD=$(tput sgr0)			# Bold off
BOLD="\033[1m"			# Bold on (for printf)
UNBOLD="\033[0m"		# Bold off (for printf)
UB="$UNBOLD"			# Save $UNBOLD's value when reassigned
B1="$BOLD"			# Bolding for each die
B2="$BOLD"
B3="$BOLD"
B4="$BOLD"
B5="$BOLD"

# Formatting
FMT="  %s %s\t"			# Format for board
SP="     "			# Spacer

# Storage for dice and commands
DREF=( {1..6} )			# Dice reference for command translation
CMD=( {a..f} )			# Commands for upper section
sel=()				# Store selected dice for processing
hold=()				# Store rolled (active) dice
_hold=()			# Copy of hold for determining straights
rem=()				# Store remaining dice

# Input variable
declare -l category		# Store commands (lower-case)

dice1[1]="|         |"          # Dice arrays
dice1[2]="|       o |"
dice1[3]="|       o |"
dice1[4]="| o     o |"
dice1[5]="| o     o |"
dice1[6]="| o     o |"
dice2[1]="|    o    |"
dice2[2]="|         |"
dice2[3]="|    o    |"
dice2[4]="|         |"
dice2[5]="|    o    |"
dice2[6]="| o     o |"
dice3[1]="|         |"
dice3[2]="| o       |"
dice3[3]="| o       |"
dice3[4]="| o     o |"
dice3[5]="| o     o |"
dice3[6]="| o     o |"
dice="+---------+"
