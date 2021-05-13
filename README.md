# Shut the box - winning strategies

*Coding project to numerically analyse the best strategies to win the game [shut the box](https://en.wikipedia.org/wiki/Shut_the_box).*

## Game:

Shut the box is a game where the player is trying to remove tiles numbered 1 to x by rolling dice. The player can remove any combination of tiles that sum to the dice total. Once the tiles are removed, they cannot be used again. The player is aiming to remove all tiles. For example, if the player rolls 7, they can remove the tile(s)numbered: [7], [1,6], [2, 5], [3, 4], and [1, 2, 4].

Winning the game can depend on the version being played, but here I look at methods to reduce the average score (sum of all tiles left in the game), or to maximise the probability of removing all tiles.

## Results:

The results are presented in **Numerical Tests**, with an overview of this given in **TL;DR**.

## Code information:

The game simulations are presented in python, Julia, and fortran 2008. Each version in the different languages do effectively the same thing, however the Julia code is the most complete as this was used to output the results.

The simulations were run on a 2020 Macbook Air (M1). Very rough run times are presented below for 1,000,000 games run (9-tile variant).

| Language     | Arcutecture - Kind   | Run Time (s) |
| ------------ | -------------------- | ------------ |
| python       | Native (Apple)       | 18.6s        |
| julia        | Emulated (Rosetta 2) | 2.9s         |
| Fortran 2008 | Native (Apple)       | 1.1s         |
