#!/bin/echo This file is a part of yahtzee

_exit()
{
    stty sane
    printf "\e[?12l\e[?25h"
    exit 0
}

_abort()
{
    _add_total
    if [ $GRAND_TOTAL -gt 9 ]; then
      _record_score "aborted"
    fi
    printf "\n\n\t%s\n\n" "${BO}GAME ABORTED WITH SCORE: ${GRAND_TOTAL}${LD}"
    _exit
}

_record_score()
{
    if [ ! -d $SCORE_DIR ]; then
      mkdir -p $SCORE_DIR
    fi
    if [ $GRAND_TOTAL -lt 100 ]; then
      GRAND_TOTAL=0$GRAND_TOTAL
    fi
    local ENDMSG="$1"
    local date=$(date)
    local data="$date | $PLAYER | $GRAND_TOTAL | $ENDMSG"
    echo "$data" >> ${SCORE_DIR}/${SCORE_FILE}
}
