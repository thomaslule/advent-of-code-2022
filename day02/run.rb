# frozen_string_literal: true

class Rock
  def self.value
    1
  end

  def self.beats
    Scissors
  end

  def self.beaten_by
    Paper
  end
end

class Paper
  def self.value
    2
  end

  def self.beats
    Rock
  end

  def self.beaten_by
    Scissors
  end
end

class Scissors
  def self.value
    3
  end

  def self.beats
    Paper
  end

  def self.beaten_by
    Rock
  end
end

def calculate_score(them, me)
  return me.value + 6 if me.beats == them

  return me.value if me.beaten_by == them

  me.value + 3
end

score = 0

File.readlines('input.txt', chomp: true).each do |line|
  round_array = line.split
  them = case round_array[0]
         when 'A'
           Rock
         when 'B'
           Paper
         else
           Scissors
         end
  me = case round_array[1]
       when 'X'
         Rock
       when 'Y'
         Paper
       else
         Scissors
       end
  score += calculate_score(them, me)
end

puts("part 1 #{score}")

score2 = 0

File.readlines('input.txt', chomp: true).each do |line|
  round_array = line.split
  them = case round_array[0]
         when 'A'
           Rock
         when 'B'
           Paper
         else
           Scissors
         end
  me = case round_array[1]
       when 'X' # lose
         them.beats
       when 'Y' # draw
         them
       else # win
         them.beaten_by
       end
  score2 += calculate_score(them, me)
end

puts("part 2 #{score2}")
