unsorted_array = Array.new(10) {rand(0...100)} #sorted: [0,1,2,4,5,9]


def bubble_sort(array)
    sorted = false

    until sorted do
        swapped = false

        for i in 1...array.length do
            if array[i-1] < array[i]
                next
            else
                swapped = true

                temp = array[i-1]
                array[i-1] = array[i]
                array[i] = temp
            end
        end

        if swapped == false
            sorted = true
        end

    end
    array
end

sorted_array = bubble_sort(unsorted_array)
p sorted_array