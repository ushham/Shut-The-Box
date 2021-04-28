using Plots
using Dates

starttime = Dates.now()

max_tile = 9
one_dice = true
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
    arr_len = length(arr)
    for i in 1:arr_len
        arr_i = arr[i]
        if arr_i in drop_num
            arr[i] = 0
        end
    end
    return arr
end

function combo_gen(numbers, target, partial = Int16[], partial_sum = 0)

    if partial_sum == target
        global res = vcat(res, [partial])
        return res
    end
    if partial_sum >= target
        return nothing
    end
    num_len = length(numbers)
    for i in enumerate(reverse(numbers))
        remaining = numbers[1:(num_len - i[1])]

        combo_gen(remaining, target, vcat(partial, i[2]), partial_sum + i[2])
    end

end


function possible_combos(numbers, target)
    global res = Int16[]
    combo_gen(numbers, target)
    return res
end

function make_combos(arr)
    output = Int16[]
    for dice in 1:12
        output = vcat(output, [possible_combos(arr, dice)])
    end
    return output
end

function game_play(arr, combos)
    game_going = true
    round_score = zeros(Int16, max_tile + 1)
    round_score[1] = sum(arr)

    idx = 1
    while (sum(arr) > 0) & game_going
        dice = roll_dice(arr)
        moves = combos[dice]

        combo_looking = false
        n = 0
        while (~combo_looking) & (n < length(moves))
            n += 1
            drops = moves[n]
            if possible_drop(arr, drops)
                idx += 1
                arr = drop_tiles(arr, drops)
                round_score[idx] = sum(arr)
                combo_looking = true
            end
        end
        game_going = combo_looking
    end
    final_score = round_score[idx]
    idx += 1
    for i in idx:max_tile
        round_score[i] = final_score
    end
    return round_score
end


println("Prep")
new_arr = Int16[x for x in 1:max_tile]
combinations = make_combos(new_arr)

function mult_games(n)
    println("Running games")
    scores = zeros(Int16, n)
    for i in 1:n
        arr = copy(new_arr)
        val = game_play(copy(new_arr), combinations)[max_tile]
        scores[i] = val
    end
    return scores
end
scores = mult_games(1000000)

println("Prepping Results")
x_val = [x for x in 0:sum(1:max_tile)]
y = copy(x_val)

for i in x_val
    y[i+1] = length([x for x in scores if x == i])
end 

y = y./sum(y)

println(string(y[1] * 100) * "%")
print(Dates.now() - starttime)
plot(y)

