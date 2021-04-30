import numpy as np
import random
import matplotlib.pyplot as plt
import datetime as dt


class play_game:
    # Game parameters
    max_tile = 9
    one_dice = False
    one_dice_num = 6    #Number under which one dice can be used

    dice_num = 6    # Size of dice 1-x
    def __init__(self):
        self.arr = [x for x in range(1, self.max_tile + 1)]

    def roll_dice(self):
        if self.one_dice and (max(self.arr) <= self.one_dice_num):
            dice = random.randint(1, self.one_dice_num)
        else:
            dice = random.randint(1, self.one_dice_num) + random.randint(1, self.one_dice_num)
        
        return dice

    def possible_drop(self, drop_nums):
        #Check incrementing correctly
        increment = True
        for i in range(len(drop_nums)-1):
            increment = increment and (drop_nums[i] > drop_nums[i + 1])
        #Check if the given array is permitted for dropping tiles
        in_arr = True
        for t in drop_nums:
            if t not in self.arr:
                in_arr = False
        return in_arr and increment
    
    def drop_tiles(self, drop_nums):
        #Drop given tile numbers
        self.arr = [0 if x in drop_nums else x for x in self.arr]
        return sum(self.arr)

    def possible_combos(self, numbers, target, partial=[], partial_sum=0):
        numbers = [x for x in numbers if x > 0]
        if partial_sum == target:
            yield partial
        if partial_sum >= target:
            return
        for i, n in reversed(list(enumerate(numbers))):
            remaining = numbers[:i]
            for par in self.possible_combos(remaining, target, partial + [n], partial_sum + n):
                yield par
    
    def make_combos(self):
        output = []
        for dice in range(1, 13):
            combs = []
            for res in self.possible_combos(self.arr, dice):
                combs.append(res)
            output.append(combs)
        return output

    def game_play(self, combos):
        game_going = True
        round_score = [sum(self.arr)]

        while (sum(self.arr) > 0) and game_going:
            dice = self.roll_dice()

            #moves = self.possible_combos(self.arr, dice)
            moves = combos[dice-1]
            
            combo_looking = False
            n = 0
            while not(combo_looking) and (n < len(moves)):
                drops = moves[n]
              
                if self.possible_drop(drops):
                    round_score.append(self.drop_tiles(drops))
                    combo_looking = True
                n += 1
            game_going = combo_looking
        
        round_score = [round_score[x] if x < len(round_score) else round_score[-1] for x in range(self.max_tile)]
        return round_score


if __name__ == "__main__":
    starttime = dt.datetime.now()

    arr = []
    n = 100000
    combinations = play_game().make_combos()
    for i in range(n):
        arr.append(play_game().game_play(combinations))
    arr = np.array(arr)

    final_score = arr[:, -1]

    x = np.linspace(0, 78, 79, dtype=int)
    y = np.empty_like(x)
    for i in x:
        y[i] = np.count_nonzero(final_score == i)

    y = y / n
    print(dt.datetime.now() - starttime)
    plt.plot(x, y)
    plt.show()
    print(y[0])
    
