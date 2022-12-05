# frozen_string_literal: true

class Stack
  attr_accessor :name

  def initialize(name, column)
    @name = name
    @column = column
    @content = []
  end

  def load_line(line)
    my_load = line[@column]
    return if my_load == " "

    @content.unshift(my_load)
  end

  def take(quantity = 1)
    @content.pop(quantity)
  end

  def add(items)
    @content.push(*items)
  end

  def top_item
    @content.last
  end

  def to_s
    "Stack #{@name} containing #{@content}"
  end
end

class Crane
  def initialize(stacks)
    @stacks = stacks
  end

  def interpret_order(order)
    result = /move (\d+) from (\d) to (\d)/.match(order)
    quantity = result[1].to_i
    from = find_stack(result[2])
    to = find_stack(result[3])
    move(from, to, quantity)
  end

  def find_stack(name)
    @stacks.find { |stack| stack.name == name }
  end
end

class Crane9000 < Crane
  def move(from, to, quantity)
    quantity.times { to.add(from.take) }
  end
end

class Crane9001 < Crane
  def move(from, to, quantity)
    to.add(from.take(quantity))
  end
end

def init_stacks
  [
    Stack.new("1", 1),
    Stack.new("2", 5),
    Stack.new("3", 9),
    Stack.new("4", 13),
    Stack.new("5", 17),
    Stack.new("6", 21),
    Stack.new("7", 25),
    Stack.new("8", 29),
    Stack.new("9", 33)
  ]
end

if __FILE__ == $PROGRAM_NAME
  stacks1 = init_stacks
  stacks2 = init_stacks
  crane9000 = Crane9000.new(stacks1)
  crane9001 = Crane9001.new(stacks2)

  File.readlines("input.txt", chomp: true).each do |line|
    if line.strip.start_with?("[")
      stacks1.each { |stack| stack.load_line(line) }
      stacks2.each { |stack| stack.load_line(line) }
      next
    end
    next unless line.start_with?("move")

    crane9000.interpret_order(line)
    crane9001.interpret_order(line)
  end

  tops1 = stacks1.map(&:top_item)
  tops2 = stacks2.map(&:top_item)
  puts "part 1 #{tops1.join}"
  puts "part 2 #{tops2.join}"
end
