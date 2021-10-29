# frozen_string_literal: true

require './lib/tree'

tree = Tree.new(Array.new(15) { rand(1..100) })

tree.pretty_print
puts "Is tree balanced? #{tree.balanced?}"
puts "Preorder: #{tree.preorder}"
puts "Postorder: #{tree.postorder}"
puts "Inorder: #{tree.inorder}"

puts 'Inserting random numbers(100 - 150) into tree'
random_insert = Array.new(10) { rand(100...150) }
random_insert.each { |value| tree.insert(value) }

puts 'Tree should be unbalanced.'
tree.pretty_print
puts "Is tree balanced? #{tree.balanced?}"

puts 'Rebalancing the tree!'
tree.rebalance
tree.pretty_print
puts "Is tree rebalanced? #{tree.balanced?}"
puts "Preorder: #{tree.preorder}"
puts "Postorder: #{tree.postorder}"
puts "Inorder: #{tree.inorder}"
