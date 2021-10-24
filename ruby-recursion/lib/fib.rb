# frozen_string_literal: true

def fib(num)
  iteration = 0
  arr = []
  while iteration <= num
    iteration < 2 ? arr.push(iteration) : arr.push(arr[iteration - 1] + arr[iteration - 2])
    iteration += 1
  end
  arr
end

def rec_fib(num)
  num < 2 ? num : rec_fib(num - 1) + rec_fib(num - 2)
end


