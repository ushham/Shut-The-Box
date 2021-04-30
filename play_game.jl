using Plots
using Dates
using DelimitedFiles

starttime = Dates.now()

max_tile = 9
one_dice = false
one_dice_num = 6    #when open tiles are equal to or less than this number, one dice is used

reduce_tile_drops = true
tiles_spaced = true

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
    if reduce_tile_drops
        lst = enumerate(reverse(numbers))
    else
        lst = enumerate(numbers)
    end

    for i in lst
        if reduce_tile_drops
            remaining = numbers[1:(num_len - i[1])]
        else
            remaining = numbers[i[1]+1:num_len]
        end

        combo_gen(remaining, target, vcat(partial, i[2]), partial_sum + i[2])
    end

end

function possible_combos(numbers, target)
    global res = Int16[]
    combo_gen(numbers, target)
    return res
end

function reverse_combos(arr)
    out_arr = []
    arr_len = [length(x) for x in arr]
    for i in unique(arr_len)
        sub_arr = arr[(arr_len .>= i) .& (arr_len .<= i)]
        if length(sub_arr) == 1
            out_arr = vcat(out_arr, sub_arr)
        else
            for ele in reverse(sub_arr)
                out_arr = vcat(out_arr, [ele])
            end
        end
    end
    return out_arr
end

function make_combos(arr)
    output = Int16[]
    for dice in 1:12
        if tiles_spaced
            output = vcat(output, [possible_combos(arr, dice)])
        else
            output = vcat(output, [reverse_combos(possible_combos(arr, dice))])
        end
    end
    return output
end

function game_play(arr, combos)
    game_going = true
    round_score = zeros(Int16, max_tile + 1)
    round_tiles = zeros(Int16, max_tile + 1)
    round_score[1] = sum(arr)
    round_tiles[1] = count(arr .> 0)

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
                round_tiles[idx] = count(arr .> 0)
                combo_looking = true
            end
        end
        game_going = combo_looking
    end
    final_score = round_score[idx]
    final_tile = round_tiles[idx]
    idx += 1
    for i in idx:max_tile
        round_score[i] = final_score
        round_tiles[i] = final_tile
    end
    return round_score, round_tiles, arr
end

function mult_games(n)
    println("Running games")
    scores = zeros(Int16, (n, max_tile+1))
    tiles = zeros(Int16, (n, max_tile+1))
    results = zeros(Int16, (n, max_tile))
    for i in 1:n
        arr = copy(new_arr)
        val, til, arr = game_play(copy(new_arr), combinations)
        scores[i, :] = val
        tiles[i, :] = til
        results[i, :] = arr
    end
    return scores, tiles, results
end

println("Prep")
new_arr = Int16[x for x in 1:max_tile]
combinations = make_combos(new_arr)

scores, tiles, results = mult_games(10000)

println("Prepping Results")
x_val = [x for x in 0:sum(1:max_tile)]
y = copy(x_val)

for i in x_val
    y[i+1] = length([scores[x, max_tile] for x in 1:size(scores, 1) if scores[x, max_tile] == i])
end 

y = y./sum(y)

println(string(y[1] * 100) * "%")
println(Dates.now() - starttime)
begin
    file_id = ""
    if one_dice
        file_id = file_id * "1D-"
    else
        file_id = file_id * "2D-"
    end
    if reduce_tile_drops
        file_id = file_id * "MT-"
    else
        file_id = file_id * "RT-"
    end
    if tiles_spaced
        file_id = file_id * "E"
    else
        file_id = file_id * "M"
    end
end

loc = "/Users/ushhamilton/Documents/03 Programming/Julia/Shut The Box/Outputs/"
writedlm(loc * "Score_Output " * file_id * ".csv", scores, ',')
writedlm(loc * "Array_Output " * file_id * ".csv", results, ',')
writedlm(loc * "Tile_Output " * file_id * ".csv", tiles, ',')
println(file_id)
plot(x_val, y)