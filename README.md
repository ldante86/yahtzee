# yahtzee
The dice game

###### AUTHOR: Luciano D. Cecere
###### COPYRIGHT: 2015 - GPL-2

## USAGE
  **yahtzee [option]**

## OPTION
  **-h --help**	Show this screen and exit

## GAMEPLAY
 Dice are selected by their position number (1-5).

 Values are applied to game sheet categories by using
 the commands which appear between [ ] on the sheet.

 Selecting a category in which the selected dice don't
 fit will set that category to 0. This is a sacrifice.

 If the upper section (ONES - SIXES) tallies up to 63
 or more, a 35 bonus is added to score.

 Because this is a one player game, the object is to
 get the highest score possible.

 Scores are recorded to ~/.yahtzee/yahtzee-scores
 
## BUGS
 Dice cannot be deselected (yet).
