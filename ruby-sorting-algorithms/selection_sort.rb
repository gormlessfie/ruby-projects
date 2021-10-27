def selection_sort(array)
  i = 0
  min_value = array.delete(array[i..array.length].min)
  array.unshift(min_value)

  while i < array.length
    min_value = array.delete(array[i..array.length].min)
    array.unshift(min_value)
    i += 1
  end
  array.reverse
end

p selection_sort([2, 5, 1, 6, 7])
