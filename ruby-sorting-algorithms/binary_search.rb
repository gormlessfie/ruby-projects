def binary_search(value, array, index = 0)
  middle = array.size / 2

  if array[middle] == value
    return array.index(value) + index
  elsif array.size <= 1
    return -1
  else
    if array[middle] > value
      p array
      binary_search(value, array[arr.index(arr.first)..middle], index)
    else
      p array
      binary_search(value, array[middle..array.size], index + middle)
    end
  end
end

arr = [3, 1, 5, 7, 9, 2, 13, 29, 50, 20, 11, 13, 66]

def mergesort(array)
  return array if array.size <= 1

  left = mergesort(array.slice(0, array.size / 2))
  right = mergesort(array.slice(array.size / 2, array.size))
  merge(left, right)
end

def merge(left, right)
  temp_arr = []
  until left.empty? || right.empty?
    if left[0] < right[0]
      temp_arr.push(left.shift)
    else
      temp_arr.push(right.shift)
    end
  end
  temp_arr + left + right
end

sorted_arr = mergesort(arr)

p binary_search(50, sorted_arr)
