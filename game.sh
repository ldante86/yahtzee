#!/bin/echo This file is a part of yahtzee

_select_category()
{
    printf "\n\n\n  Select [category]: " ; read category

    case $category in
        x)  if [ $CHANCE = - ]; then
               _chance
            else
               continue
            fi ;;
    [a-f])  for ((y=0; y<${#CMD[@]}; y++))
            do
              if [ "${CMD[y]}" = "$category" ]; then
                _apply_to_upper ${DREF[y]}
              fi
            done ;;
        h)  if [ $full_house -eq 1 ] &&
               [ $FULL_HOUSE = - ]
            then
              FULL_HOUSE=$FH_SCORE
            elif [ $full_house -eq 0 ] &&
                 [ $FULL_HOUSE = - ]
            then
              FULL_HOUSE=0
            else
              _select_category
            fi ;;
        r)  if [ $four_of_a_kind -eq 1 -o \
                 $yahtzee -eq 1 ] &&
               [ $FOUR_OF_A_KIND = - ]
            then
              FOUR_OF_A_KIND=$((single_die * 4))
            elif [ $four_of_a_kind -eq 0 ] &&
                 [ $FOUR_OF_A_KIND = - ]
            then
              FOUR_OF_A_KIND=0
            else
              _select_category
            fi ;;
        t)  if [ $three_of_a_kind -eq 1 -o \
                 $four_of_a_kind -eq 1 -o \
                 $full_house -eq 1 -o \
                 $yahtzee -eq 1 ] &&
               [ $THREE_OF_A_KIND = - ]
            then
              THREE_OF_A_KIND=$((single_die * 3))
            elif [ $three_of_a_kind -eq 0 ] &&
                 [ $THREE_OF_A_KIND = - ]
            then
              THREE_OF_A_KIND=0
            else
              _select_category
            fi ;;
        s)  if [ $small_straight -eq 1 -o \
                 $large_straight -eq 1 ] &&
               [ $SMALL_STRAIGHT = - ]
            then
              SMALL_STRAIGHT=$SS_SCORE
            elif [ $small_straight -eq 0 ]
                 [ $SMALL_STRAIGHT = - ]
            then
              SMALL_STRAIGHT=0
            else
              _select_category
            fi ;;
        l)  if [ $large_straight -eq 1 ] &&
               [ $LARGE_STRAIGHT = - ]
            then
              LARGE_STRAIGHT=$LS_SCORE
            elif [ $large_straight -eq 0 ] &&
                 [ $LARGE_STRAIGHT = - ]
            then
              LARGE_STRAIGHT=0
            else
              _select_category
            fi ;;
        y)  if [ $yahtzee -eq 1 ] &&
               [ $YAHTZEE -gt 0 ]
            then
              ((YAHTZEE+=YAHTZEE_BONUS))
            elif [ $yahtzee -eq 1 ] &&
                 [ $YAHTZEE = - ]
            then
              YAHTZEE=0
              ((YAHTZEE+=YAHTZEE_BONUS))
            elif [ $yahtzee -eq 0 ] &&
                 [ $YAHTZEE = - ]
            then
              YAHTZEE=0
            else
              _select_category
            fi ;;
        x)  if [ $CHANCE = - ]; then
              _chance
            else
              _select_category
            fi ;;
        q)  _abort ;;
        *) _select_category ;;
    esac
}

_chance()
{
    CHANCE=$((hold[0]+hold[1]+hold[2]+hold[3]+hold[4]))
}


_tally_singles()
{
    local a=0 b=0 c=0 d=0 e=0 f=0
    single_die=0 # Not local!

    for i in ${hold[@]}
    do
      case $i in
        1)  ((a++)) ;;
        2)  ((b++)) ;;
        3)  ((c++)) ;;
        4)  ((d++)) ;;
        5)  ((e++)) ;;
        6)  ((f++)) ;;
      esac
   done

   [ $a -eq 3 -o $a -eq 4 -o $a -eq 5 ] && single_die=1
   [ $b -eq 3 -o $b -eq 4 -o $b -eq 5 ] && single_die=2
   [ $c -eq 3 -o $c -eq 4 -o $c -eq 5 ] && single_die=3
   [ $d -eq 3 -o $d -eq 4 -o $d -eq 5 ] && single_die=4
   [ $e -eq 3 -o $e -eq 4 -o $e -eq 5 ] && single_die=5
   [ $f -eq 3 -o $f -eq 4 -o $f -eq 5 ] && single_die=6
}

_count_multiples()
{
    for i in $ones $twos $threes $fours $fives $sixes
    do
      case $i in
        2)  ((++pair)) ;;
        3)  ((++three_of_a_kind)) ;;
        4)  ((++four_of_a_kind)) ;;
        5)  ((++yahtzee)) ;;
      esac
      shift
    done
}

_apply_to_upper()
{
    local a=0 b=0 c=0 d=0 e=0 f=0
    local single_die=0 # Local!

    for i in ${hold[@]}
    do
      if [ $i -eq $1 ]; then
        ((++single_die))
      fi
    done

    if [ $single_die -eq 0 ]; then
      case $1 in
        1)  ONES=0 ;;
        2)  TWOS=0 ;;
        3)  THREES=0 ;;
        4)  FOURS=0 ;;
        5)  FIVES=0 ;;
        6)  SIXES=0 ;;
      esac
      return
    fi

    case $1 in
      1)  [[ $ONES = - ]] && ONES=$((single_die * $1)) || _select_category ;;
      2)  [[ $TWOS = - ]] && TWOS=$((single_die * $1)) || _select_category ;;
      3)  [[ $THREES = - ]] && THREES=$((single_die * $1)) || _select_category ;;
      4)  [[ $FOURS = - ]] && FOURS=$((single_die * $1)) || _select_category ;;
      5)  [[ $FIVES = - ]] && FIVES=$((single_die * $1)) || _select_category ;;
      6)  [[ $SIXES = - ]] && SIXES=$((single_die * $1)) || _select_category ;;
    esac
}

_sort_dice()
{
    local save=() t
    for (( i=0; i<${#hold[@]}; i++ ))
    do
      t=$i
      for (( j=i; j<${#hold[@]}; j++ ))
      do
        if [ ${hold[j]} -le ${hold[t]} ]; then
          t=$j
       fi
      done
      save=${hold[i]}
      hold[i]=${hold[t]}
      hold[t]=$save
    done
}

_add_total()
{
    if [[ $ONES != - ]] &&
       [[ $TWOS != - ]] &&
       [[ $THREES != - ]] &&
       [[ $FOURS != - ]] &&
       [[ $FIVES != - ]] &&
       [[ $SIXES != - ]]
    then
      local upper=$((ONES+TWOS+THREES+FOURS+FIVES+SIXES))
      if [ $upper -ge $GRANT_BONUS ] &&
         [ $BONUS = - ]
      then
        UPPER=1
        BONUS=$UPPER_BONUS
      elif [ $upper -lt $GRANT_BONUS ] &&
           [ $BONUS = - ]
      then
        UPPER=1
        BONUS=0
      fi
    fi

    UPPER_TOTAL=$((\
      ${ONES/-/0}+\
      ${TWOS/-/0}+\
      ${THREES/-/0}+\
      ${FOURS/-/0}+\
      ${FIVES/-/0}+\
      ${SIXES/-/0}\
    ))

    GRAND_TOTAL=$((\
      $UPPER_TOTAL+\
      ${THREE_OF_A_KIND/-/0}+\
      ${FOUR_OF_A_KIND/-/0}+\
      ${FULL_HOUSE/-/0}+\
      ${SMALL_STRAIGHT/-/0}+\
      ${LARGE_STRAIGHT/-/0}+\
      ${CHANCE/-/0}+\
      ${BONUS/-/0}+\
      ${YAHTZEE/-/0}\
    ))

    if [[ $THREE_OF_A_KIND != - ]] &&
       [[ $FOUR_OF_A_KIND != - ]] &&
       [[ $FULL_HOUSE != - ]] &&
       [[ $SMALL_STRAIGHT != - ]] &&
       [[ $LARGE_STRAIGHT != - ]] &&
       [[ $CHANCE != - ]] &&
       [[ $BONUS != - ]] &&
       [[ $YAHTZEE != - ]] &&
       [ $UPPER -eq 1 ]
    then
      clear
      _show_dice
      _show_game_sheet
      _record_score "completed"
      printf "\n\n\t%s\n\n" "${BO}GAME OVER - SCORE: ${GRAND_TOTAL}${LD}"
      _exit
    fi
}

_detect_pattern()
{
    ones=0 twos=0 threes=0 fours=0 fives=0 sixes=0 pair=0
    three_of_a_kind=0 four_of_a_kind=0 yahtzee=0
    large_straight=0 small_straight=0 full_house=0

    for i in ${hold[@]}
    do
      case $i in
        1)  ((ones++)) ;;
        2)  ((twos++)) ;;
        3)  ((threes++)) ;;
        4)  ((fours++)) ;;
        5)  ((fives++)) ;;
        6)  ((sixes++)) ;;
      esac
    done

    _count_multiples

    _sort_dice

    _tally_singles

    _hold=( "${hold[@]}" )
    for ((i=0; i<${#_hold[@]}; i++))
    do
      if [ -z "${_hold[i+1]}" ]; then
        break
      fi
      if [ $(( ${_hold[i+1]} - ${_hold[i]} )) -ne 1 ]; then
        if [ $i -eq 0 ]; then
          unset _hold[i]
        else
          unset _hold[i+1]
        fi
      elif [ ${_hold[i]} -eq ${_hold[i+1]} ]; then
        unset _hold[i]
      fi
      _hold=( "${_hold[@]}" )
    done

    local str="${_hold[@]}"

    if [ "$str" = "1 2 3 4 5" ] ||
       [ "$str" = "2 3 4 5 6" ]
    then
      large_straight=1
      small_straight=1
    fi

    if [ "$str" = "1 2 3 4" ] ||
       [ "$str" = "2 3 4 5" ] ||
       [ "$str" = "3 4 5 6" ]
    then
      small_straight=1
    fi

    # Redundant, just as a reminder.
#    if [ $yahtzee -eq 1 ]; then
#      yahtzee=1
#    fi

    if [ $pair -eq 1 ] &&
       [ $three_of_a_kind -eq 1 ]
    then
      full_house=1
    fi

    if [ $four_of_a_kind -eq 1 ] ||
       [ $yahtzee -eq 1 ]
    then
      four_of_a_kind=1
    fi

    if [ $three_of_a_kind -eq 1 ] ||
       [ $four_of_a_kind -eq 1 ] ||
       [ $yahtzee -eq 1 ]
    then
      three_of_a_kind=1
    fi

    if [ $three_of_a_kind -eq 1 ] &&
       [ $four_of_a_kind -eq 1 ] ||
       [ $yahtzee -eq 1 ]
    then
      four_of_a_kind=1
      three_of_a_kind=1
    fi
}

_roll_dice()
{
    case $1 in
      1)  echo $((RANDOM % 6 + 1)) ;;
      5)  d1=$((RANDOM % 6 + 1))
          d2=$((RANDOM % 6 + 1))
          d3=$((RANDOM % 6 + 1))
          d4=$((RANDOM % 6 + 1))
          d5=$((RANDOM % 6 + 1))
    esac
}

_get_remaining_dice()
{
    for d in ${sel[@]}
    do
      for ((i=0; i<${#rem[@]}; i++))
      do
        if [ $d -eq ${rem[i]} ]; then
          unset rem[i]
          rem=( "${rem[@]}" )
        fi
      done
    done
}

_select_dice()
{
    rem=( {1..5} )

    for roll in {1..4}
    do
      _show_dice
      _show_game_sheet
      printf "\n  Roll: $roll\n"
      printf "\n  Select dice: " ; read -a sel

      [[ ${sel[@]} = *[q]* ]] && _abort
      [[ ${sel[@]} = *[a-z67890]* ]] && continue

      _unbold_dice

      _get_remaining_dice

      [ $roll -eq 3 ] && break # Stop here

      for i in ${rem[@]}
      do
        case $i in
          1) d1=$(_roll_dice 1) ;;
          2) d2=$(_roll_dice 1) ;;
          3) d3=$(_roll_dice 1) ;;
          4) d4=$(_roll_dice 1) ;;
          5) d5=$(_roll_dice 1) ;;
        esac
      done

      # If all dice are selected, skip remining rolls.
      if [ ${#sel[@]} -eq 5 ] ||
         [ ${#rem[@]} -eq 0 ]
      then
        break
      fi
    done
}

_unbold_dice()
{
    for i in ${sel[@]}
    do
      case $i in
        1) B1=$UB ;;
        2) B2=$UB ;;
        3) B3=$UB ;;
        4) B4=$UB ;;
        5) B5=$UB ;;
      esac
    done
}
