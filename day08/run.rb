# frozen_string_literal: true

def all_smaller?(height, others)
  others.all? { |other_height| other_height < height }
end

def number_visible(height, others)
  count = 0
  others.each do |other_height|
    count += 1
    break if other_height >= height
  end
  count
end

class Forest
  def initialize
    @rows = []
  end

  def add_row(row)
    @rows.push(row.chars)
  end

  def each_tree(&)
    Enumerator.new do |y|
      (0..(@rows.length - 1)).each { |row| (0..(@rows[0].length - 1)).each { |column| y.yield [row, column] } }
    end.each(&)
  end

  def visible?(tree)
    height = @rows[tree[0]][tree[1]]
    on_left, on_right, on_top, on_bottom = tree_neighbors(tree)

    return true if all_smaller?(height, on_left)

    return true if all_smaller?(height, on_right)

    return true if all_smaller?(height, on_top)

    return true if all_smaller?(height, on_bottom)

    false
  end

  def view(tree)
    height = @rows[tree[0]][tree[1]]
    on_left, on_right, on_top, on_bottom = tree_neighbors(tree)

    number_on_left = number_visible(height, on_left)
    number_on_right = number_visible(height, on_right)
    number_on_top = number_visible(height, on_top)
    number_on_bottom = number_visible(height, on_bottom)

    number_on_left * number_on_right * number_on_top * number_on_bottom
  end

  def tree_neighbors(tree)
    row_number, column_number = tree
    row = @rows[row_number]
    column = @rows.map { |r| r[column_number] }
    on_left = column_number.positive? ? row[0..(column_number - 1)].reverse : []
    on_right = column_number < 98 ? row[(column_number + 1)..98] : []
    on_top = row_number.positive? ? column[0..(row_number - 1)].reverse : []
    on_bottom = row_number < 98 ? column[(row_number + 1)..98] : []
    [on_left, on_right, on_top, on_bottom]
  end
end

if __FILE__ == $PROGRAM_NAME
  forest = Forest.new
  File.readlines("input.txt", chomp: true).each do |line|
    forest.add_row(line)
  end

  part1 = forest.each_tree.filter { |tree| forest.visible?(tree) }.length
  part2 = forest.each_tree.map { |tree| forest.view(tree) }.max

  puts "part 1 #{part1}"
  puts "part 2 #{part2}"
end
