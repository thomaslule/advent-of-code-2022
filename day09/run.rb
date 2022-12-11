# frozen_string_literal: true

require "set"

class Coord
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def move(movement)
    Coord.new(@x + movement.x, @y + movement.y)
  end

  def distance(other)
    Coord.new(other.x - @x, other.y - @y)
  end

  def eql?(other)
    self.class == other.class &&
      @x == other.x && @y == other.y
  end

  def hash
    [self.class, @x, @y].hash
  end

  def to_str
    "(#{@x}, #{@y})"
  end

  def self.from_direction(direction)
    return Coord.new(0, 1) if direction == "U"
    return Coord.new(1, 0) if direction == "R"
    return Coord.new(0, -1) if direction == "D"
    return Coord.new(-1, 0) if direction == "L"
  end
end

class Head
  attr_accessor :coord

  def initialize(coord)
    @coord = coord
  end

  def move(movement)
    @coord = @coord.move(movement)
  end
end

class Tail
  def initialize(coord, head)
    @coord = coord
    @head = head
    @visited = Set[@coord]
  end

  def move
    distance = @coord.distance(@head.coord)
    return if distance.x.abs <= 1 && distance.y.abs <= 1

    movement = Coord.new(reduce_to_one(distance.x), reduce_to_one(distance.y))
    @coord = @coord.move(movement)
    @visited.add(@coord)
  end

  def number_visited
    @visited.size
  end

  def reduce_to_one(n)
    return 1 if n.positive?

    return -1 if n.negative?

    0
  end
end

if __FILE__ == $PROGRAM_NAME
  origin = Coord.new(0, 0)
  head = Head.new(origin)
  tail = Tail.new(origin, head)

  File.readlines("input.txt", chomp: true).each do |line|
    direction, repeat = line.split
    movement = Coord.from_direction(direction)
    repeat.to_i.times do
      head.move(movement)
      tail.move
    end
  end

  puts tail.number_visited
end
