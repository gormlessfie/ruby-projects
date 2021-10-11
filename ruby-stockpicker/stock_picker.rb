stock_price_per_day = [3, 2, 6, 25, 6, 26, 23, 4, 23, 15, 1, 6, 5]

def stock_picker(input_array)
    biggest_diff = {
        diff: 0,
        index_buy: 0,
        index_sell: 0,
    }

    for i in 0...input_array.length do
        for j in (i+1)...input_array.length do
            if input_array[i] < input_array[j]
                if (biggest_diff[:diff] < (input_array[j] - input_array[i]))

                    biggest_diff[:diff] = input_array[j] - input_array[i]
                    biggest_diff[:index_buy] = i
                    biggest_diff[:index_sell] = j
                end
            else
                next
            end
        end
    end
    biggest_diff
    puts "Buy on day #{biggest_diff[:index_buy]}, Sell on day #{biggest_diff[:index_sell]}, Profit of $#{biggest_diff[:diff]}"
end

stock_picker(stock_price_per_day)