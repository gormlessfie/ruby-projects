# frozen_string_literal: true

def my_mergesort(arr)
  return arr if arr.length <= 1

  middle = arr.length / 2

  left = my_mergesort(arr.slice(0, middle))
  right = my_mergesort(arr.slice(middle, arr.size))

  merge(left, right)
end

def merge(left, right)
  temp_arr = []
  until left.empty? || right.empty?
    if left.first <= right.first
      temp_arr.push(left.shift)
    else
      temp_arr.push(right.shift)
    end
  end
  temp_arr + left + right
end

array = [5, 2, 1, 3, 6, 4, 9, 8, 10, 13]

p my_mergesort(array)
