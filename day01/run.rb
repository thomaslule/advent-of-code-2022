# frozen_string_literal: true

by_elf = []
current_elf = []

File.readlines('input.txt', chomp: true).each do |line|
  if line == ''
    by_elf.push(current_elf)
    current_elf = []
  else
    current_elf.push(line.to_i)
  end
end

sum_by_elf = by_elf.map(&:sum)

puts("part 1 #{sum_by_elf.max}")

# to optimize later, of course
sorted = sum_by_elf.sort.reverse

puts("part 2 #{sorted[0] + sorted[1] + sorted[2]}")
