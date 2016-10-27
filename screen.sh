#!/bin/echo This file is a part of yahtzee

_show_dice()
{
    clear
    hold=( $d1 $d2 $d3 $d4 $d5 $d6 )
    printf "\n${SP}$B1$dice$UB  $B2$dice$UB  $B3$dice$UB  $B4$dice$UB  $B5$dice$UB\n"
    printf "$B1${SP}${dice1[d1]}$UB  $B2${dice1[d2]}$UB  $B3${dice1[d3]}$UB  $B4${dice1[d4]}$UB  $B5${dice1[d5]}$UB\n"
    printf "$B1${SP}${dice2[d1]}$UB  $B2${dice2[d2]}$UB  $B3${dice2[d3]}$UB  $B4${dice2[d4]}$UB  $B5${dice2[d5]}$UB\n"
    printf "$B1${SP}${dice3[d1]}$UB  $B2${dice3[d2]}$UB  $B3${dice3[d3]}$UB  $B4${dice3[d4]}$UB  $B5${dice3[d5]}$UB\n"
    printf "${SP}$B1$dice$UB  $B2$dice$UB  $B3$dice$UB  $B4$dice$UB  $B5$dice$UB\n"
    printf "${SP}     1            2            3            4            5\n\n\n"
}

_show_game_sheet()
{
    printf "$FMT" "[a] ONES:  " "[${ONES}]"
    printf "$FMT" "[t] THREE OF A KIND:" "[${THREE_OF_A_KIND}]"
    printf "$FMT" "[y] YAHTZEE:" "[${YAHTZEE}]"
    echo
    printf "$FMT" "[b] TWOS:  " "[${TWOS}]"
    printf "$FMT" "[r] FOUR OF A KIND: " "[${FOUR_OF_A_KIND}]"
    printf "$FMT" "[x] CHANCE: " "[${CHANCE}]"
    echo
    printf "$FMT" "[c] THREES:" "[${THREES}]"
    printf "$FMT" "[h] FULL HOUSE:     " "[${FULL_HOUSE}]"
    printf "$FMT" "    BONUS:  " "[${BONUS}]"
    echo
    printf "$FMT" "[d] FOURS: " "[${FOURS}]"
    printf "$FMT" "[s] SMALL STRAIGHT: " "[${SMALL_STRAIGHT}]"
    printf "$FMT" "    TOTAL:  " "[${BO}${GRAND_TOTAL}${LD}]"
    echo
    printf "$FMT" "[e] FIVES: " "[${FIVES}]"
    printf "$FMT" "[l] LARGE STRAIGHT: " "[${LARGE_STRAIGHT}]"
    echo
    printf "$FMT" "[f] SIXES: " "[${SIXES}]"
    echo
    printf "$FMT" "    UPPER: " "[${BO}${UPPER_TOTAL}${LD}]"
    echo
}

_splash()
{
    clear
    printf "\e[?25l"
    echo
	cat <<-eof
     +---------+  +---------+  +---------+  +---------+  +---------+
     |         |  |       o |  |       o |  | o     o |  | o     o |
     |    o    |  |         |  |    o    |  |         |  |    o    |
     |         |  | o       |  | o       |  | o     o |  | o     o |
     +---------+  +---------+  +---------+  +---------+  +---------+

                   ${BO}__   __    _     _  ${LD}
                   ${BO}\ \ / /_ _| |__ | |_ _______  ___  ${LD}
                    ${BO}\ V / _  | '_ \| __|_  / _ \/ _ \  ${LD}
                     ${BO}| | (_| | | | | |_ / /  __/  __/  ${LD}
                     ${BO}|_|\__,_|_| |_|\__/___\___|\___|  ${LD}

                           The classic dice game

	eof
    read -sn1
    printf "\e[?12l\e[?25h"
}

_usage()
{
	cat <<-eof
	 PROGRAM: $PROGRAM - the classic dice game
	 AUTHOR: Luciano D. Cecere
	 COPYRIGHT: 2015 - GPLv2
	 USAGE: $PROGRAM [-flag]
	 FLAG:
	  -h --help	Show this screen and exit

	 GAMEPLAY:
	  Dice are selected by their position number (1-5).

	  Values are applied to game sheet categories by using
	  the commands which appear between [ ] on the sheet.

	  Selecting a category in which the selected dice don't
	  fit will set that category to 0. This is a sacrifice.

	  If the upper section (ONES - SIXES) tallies up to $GRANT_BONUS
	  or more, a $UPPER_BONUS bonus is added to score.

	  Because this is a one player game, the object is to
	  get the highest score possible.

	  Scores are recorded to ${SCORE_DIR}/${SCORE_FILE}

	CAVEAT:
	  Dice cannot be deselected (yet).
	eof
}
