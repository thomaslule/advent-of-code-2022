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

class Knot
  attr_accessor :coord

  def initialize(coord)
    @coord = coord
  end
end

class Head < Knot
  def move(movement)
    @coord = @coord.move(movement)
  end
end

class AttachedKnot < Knot
  def initialize(coord, previous)
    super(coord)
    @previous = previous
  end

  def move
    distance = @coord.distance(@previous.coord)
    return if distance.x.abs <= 1 && distance.y.abs <= 1

    movement = Coord.new(reduce_to_one(distance.x), reduce_to_one(distance.y))
    @coord = @coord.move(movement)
  end

  def reduce_to_one(n)
    return 1 if n.positive?

    return -1 if n.negative?

    0
  end
end

class Tail < AttachedKnot
  def initialize(coord, previous)
    super(coord, previous)
    @visited = Set[@coord]
  end

  def move
    super
    @visited.add(@coord)
  end

  def number_visited
    @visited.size
  end
end

class Rope
  def initialize(coord, size)
    @knots = []
    size.times do |i|
      case i
      when 0
        @knots.push(Head.new(coord))
      when size - 1
        @knots.push(Tail.new(coord, @knots.last))
      else
        @knots.push(AttachedKnot.new(coord, @knots.last))
      end
    end
  end

  def move_head(movement)
    @knots[0].move(movement)
    @knots[1..].each(&:move)
  end

  def tail_visited
    @knots.last.number_visited
  end
end

if __FILE__ == $PROGRAM_NAME
  origin = Coord.new(0, 0)
  rope1 = Rope.new(origin, 2)
  rope2 = Rope.new(origin, 10)

  File.readlines("input.txt", chomp: true).each do |line|
    direction, repeat = line.split
    movement = Coord.from_direction(direction)
    repeat.to_i.times do
      rope1.move_head(movement)
      rope2.move_head(movement)
    end
  end

  puts "part 1 #{rope1.tail_visited}"
  puts "part 2 #{rope2.tail_visited}"
end
