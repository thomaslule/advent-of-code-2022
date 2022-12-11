# frozen_string_literal: true

require "observer"

class CPU
  include Observable

  def initialize
    @registry = 1
    @cycle = 0
  end

  def noop
    cycle
  end

  def addx(n)
    cycle
    cycle
    @registry += n
  end

  def interpret_str(line)
    if line == "noop"
      noop
    elsif line.start_with?("addx")
      addx(line.split[1].to_i)
    end
  end

  def cycle
    @cycle += 1
    changed
    notify_observers(@cycle, @registry)
  end
end

class SignalCalculator
  attr_accessor :sum

  def initialize(cpu)
    @sum = 0
    cpu.add_observer(self)
  end

  def update(cycle, register)
    return unless [20, 60, 100, 140, 180, 220].include?(cycle)

    strength = cycle * register
    @sum += strength
  end
end

class CRT
  def initialize(cpu)
    @rows = []
    cpu.add_observer(self)
  end

  def update(cycle, register)
    sprite = [register, register + 1, register + 2]
    column = cycle % 40
    @rows.push([]) if column == 1
    pixel = sprite.include?(column) ? "#" : " "
    @rows.last.push(pixel)
  end

  def draw
    @rows.each { |row| puts row.join }
  end
end

if __FILE__ == $PROGRAM_NAME
  cpu = CPU.new
  calculator = SignalCalculator.new(cpu)
  crt = CRT.new(cpu)
  File.readlines("input.txt", chomp: true).each do |line|
    cpu.interpret_str(line)
  end

  puts "part 1 #{calculator.sum}"
  crt.draw
end
