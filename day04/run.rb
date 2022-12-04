# frozen_string_literal: true

class RangesPair
  def initialize(line)
    @range1, @range2 = line.split(",").map do |range_str|
      from, to = range_str.split("-")
      (from..to)
    end
  end

  def fully_contained?
    @range1.all? { |from1| @range2.include?(from1) } || @range2.all? { |from2| @range1.include?(from2) }
  end

  def overlap?
    @range1.any? { |from1| @range2.include?(from1) } || @range2.any? { |from2| @range1.include?(from2) }
  end
end

if __FILE__ == $PROGRAM_NAME
  fully_contained_count = 0
  overlap_count = 0
  File.readlines("input.txt", chomp: true).each do |line|
    pair = RangesPair.new(line)
    fully_contained_count += 1 if pair.fully_contained?
    overlap_count += 1 if pair.overlap?
  end
  puts "part 1 #{fully_contained_count}"
  puts "part 2 #{overlap_count}"
end
