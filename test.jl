using Plots
using Dates

starttime = Dates.now()

max_tile = 9
one_dice = false
one_dice_num = 6

dice_num = 6

function roll_dice(arr)
    if one_dice & (maximum(arr) <= one_dice_num)
        dice = rand(1:dice_num)
    else
        dice = rand(1:dice_num) + rand(1:dice_num)
    end
    return dice
end

function possible_drop(arr, drop_num)
    in_arr = issubset(drop_num, arr)
    return in_arr
end

function drop_tiles(arr, drop_num)
    for i in 1:length(arr)
        if arr[i] in drop_num
            arr[i] = 0
        end
    end
    return arr
end

function combo_gen(numbers, target, partial = [], partial_sum = 0)

    if partial_sum == target
        global res = vcat(res, [partial])
        return res
    end
    if partial_sum >= target
        return nothing
    end
    for i in enumerate(reverse(numbers))
        remaining = numbers[1:(length(numbers) - i[1])]

        combo_gen(remaining, target, vcat(partial, i[2]), partial_sum + i[2])
    end

end


function possible_combos(numbers, target)
    global res = []
    combo_gen(numbers, target)
    return res
end

function make_combos(arr)
    output = []
    for dice in 1:12
        output = vcat(output, [possible_combos(arr, dice)])
    end
    return output
end

function game_play(arr, combos)
    game_going = true
    round_score = [sum(arr)]

    while (sum(arr) > 0) & game_going
        dice = roll_dice(arr)
        moves = combos[dice]

        combo_looking = false
        n = 0
        while (~combo_looking) & (n < length(moves))
            n += 1
            drops = moves[n]
            if possible_drop(arr, drops)
                arr = drop_tiles(arr, drops)
                round_score = vcat(round_score, sum(arr))
                combo_looking = true
            end
        end
        game_going = combo_looking
    end
    result = []
    for i in 1:max_tile
        if i < length(round_score)
            result = vcat(result, round_score[i])
        else
            result = vcat(result, last(round_score))
        end
    end
    return result
end


scores = []

new_arr = [x for x in 1:max_tile]
combinations = make_combos(new_arr)

for i in 1:1000
    arr = copy(new_arr)
    val = game_play(arr, combinations)
    scores = vcat(scores, [val[max_tile]])
end

x_val = [x for x in 0:sum(1:max_tile)]
y = copy(x_val)

for i in x_val
    y[i+1] = length([x for x in scores if x == i])
end 

y = y./sum(y)

plot(new_arr)
