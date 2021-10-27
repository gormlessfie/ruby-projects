def bubble_sort(array)
  array.length.times do
    for i in 1...array.length do
      next unless array[i] < array[i - 1]

      temp = array[i]
      array[i] = array[i - 1]
      array[i - 1] = temp
    end
  end
  array
end
