# frozen_string_literal: true

total = 0

def get_priority(char)
  lowercase_range = ('a'..'z')
  uppercase_range = ('A'..'Z')

  return lowercase_range.find_index(char) + 1 if lowercase_range.include?(char)

  uppercase_range.find_index(char) + 27
end

File.readlines('input.txt', chomp: true).each do |rucksack|
  compartment_size = rucksack.length / 2
  compartment1 = rucksack.slice(0..compartment_size - 1)
  compartment2 = rucksack.slice(compartment_size..rucksack.length)
  common_type = compartment1.chars.intersection(compartment2.chars)[0]
  total += get_priority(common_type)
end

puts "part 1 #{total}"

total2 = 0
current_group = []

File.readlines('input.txt', chomp: true).each do |rucksack|
  current_group.push(rucksack)
  next unless current_group.length == 3

  common_type = current_group[0].chars.intersection(current_group[1].chars).intersection(current_group[2].chars)[0]
  total2 += get_priority(common_type)
  current_group = []
end

puts "part 2 #{total2}"
