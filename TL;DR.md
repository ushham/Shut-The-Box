# Summary of Numerical Tests

## Maximise completing the game

If you want to have the best chance of removing all the tiles, these are the stratigies to follow for the 9, 10, and 12 tile version of the game. Results are given for 1 and 2 dice variants of the game, where the 1-dice variant allows the player to use only 1 dice when the remaining tiles have a maximum value of 6.

### 9, 10, & 12-Tile

If you are playing the **1-dice** variant, reduce the number of tiles removed each dice roll, and if you must remove more than 1 tile for a given roll, remove the tile combinations which are **most** closely grouped (**minimum** distance between the largest value and smallest value tiles removed).

For example, if you roll a 7, remove the tiles in this order of preference: [7], [3, 4], [2, 5], [1, 6], [1, 2, 4].

If you are playing the **2-dice** variant, reduce the number of tiles removed each dice roll, and if you must remove more than 1 tile for a given roll, remove the tile combinations which are **least** closely grouped (**maximum** distance between the largest value and smallest value tiles removed).

For example, if you roll a 7, remove the tiles in this order of preference: [7], [1, 6], [2, 5], [3, 4], [1, 2, 4].

## Minimise average score

In all versions of the game, if you want to minimise the average score you have when you run out of moves, the best strategy is to reduce the number of tiles removed each dice roll, and if you must remove more than 1 tile for a given roll, remove the tile combinations which are **least** closely grouped (**maximum** distance between the largest value and smallest value tiles removed).

For example, if you roll a 7, remove the tiles in this order of preference: [7], [1, 6], [2, 5], [3, 4], [1, 2, 4].
