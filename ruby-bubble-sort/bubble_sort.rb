# frozen_string_literal: true

unsorted_array = Array.new(10) { rand(0...100) }

def bubble_sort(array)
  sorted = false
  until sorted
    swapped = false
    for i in 1...array.length do
      next if array[i - 1] < array[i]

      swapped = true
      temp = array[i - 1]
      array[i - 1] = array[i]
      array[i] = temp
    end
    sorted = true if swapped == false
  end
  array
end

sorted_array = bubble_sort(unsorted_array)
p sorted_array
