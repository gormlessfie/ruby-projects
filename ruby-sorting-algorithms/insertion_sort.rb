def insertion_sort(array)
  i = 0
  j = 0

  while i < array.length
    j = i
    while j > 0 && array[j - 1] > array[j]
      temp = array[j - 1]
      array[j - 1] = array[j]
      array[j] = temp
      j -= 1
    end
    i += 1
  end
  array
end

p insertion_sort([5, 4, 3, 3, 2, 1])
