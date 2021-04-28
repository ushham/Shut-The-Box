# Numerical Tests - Shut the box runs

See the [wiki](https://en.wikipedia.org/wiki/Shut_the_box) for details on the game.

## Introduction

I ran numerical tests for the 9, 10 and 12 box varients of shut the box.

We assume the dice rolls are done using two 6-side dice, unless stated. For each of these I ran the versions of the game where you must use one dice once the largest tile left open is less than or equal to 6.

I also experiemented with how changing the strategy of which tiles are dropped if there are multiple permutations of tile drops availible.

## Strategies

**Open Tiles:** Tiles which have not been removed from the game.

**Score:** the sum of all open tiles.

**1D/2D:** 1D is when the player must use one dice when the open tiles have value 6 or less, 2D is when the player must use two dice at all times.

### Maximise tiles - Extremes (MT-E)

This strategy assumes that the player is trying to reduce their total score. Each dice roll, where the player can still play, will reduce the player's score, no matter which combination of tiles are closed. For this reason, the player should close the fewest number of tiles to leave the maximum number of tiles open to increase the liklihood of further dice rolls rolling an open tile number(s). 

In this strategy, for each dice roll the code will try to only close the one corrisponding tile, next a combination of two tiles, and so on. There may be multiple permutations of two (or more) tile closures. For example, if a 12 is rolled, then the possible permutations are [3, 9], [4, 8], and [5, 7]. When this is the case, we choose the highest and lowest numbers ([3, 9] in the previous example) (hence the Extreme in the title). This is done to ensure the remaining open tiles are more likely to be close to 7, which is the most likely score with a two 6-sided dice.

### Maximise tiles - Mid (MT-M) 

Same as MT-E, but I reversed the preference for permutations when multiple tiles had to be closed. In the example I gave we would preference [5, 7] over [4, 8], which is preferenced over [3, 9].

### Reduce tiles - Extremes (RT-E)

In this method we try to reduce the number of tiles open in each game. To do this I maximised the number of tiles closed with each dice roll. For example, if I roll 12 in the first roll of the game, I would close [1, 2, 3, 6]. Again, when there is an option between permutations of the same number of tile closures, we use the permutations where there is the largest difference between the lowest and highest tiles.

I knew this strategy would result in a lower probability of winning. However I wanted to test my hypotisis that this strategy would on average lead to a larger number of open tiles at the end of games.

### Reduce tiles - Mid (RT-M)

Same as RT-E but if there are multiple permutations availible of the same length, the one which has the smallest gap between first and last tile numbers is picked.

## 9-Tile varient

**MT_E:**

| Variant | 1D   | 2D   |
| ------- | ---- | ---- |
| MT-E    |      |      |

