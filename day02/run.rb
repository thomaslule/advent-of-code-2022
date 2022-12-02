# frozen_string_literal: true

$is_defeated_by = { '🪨': '✂️', '🗒️': '🪨', '✂️': '🗒️' }

def calculate_score(them, me)
  base_score_values = { '🪨': 1, '🗒️': 2, '✂️': 3 }
  base_score = base_score_values[me.to_sym]

  return base_score + 6 if them == $is_defeated_by[me.to_sym]

  return base_score if me == $is_defeated_by[them.to_sym]

  base_score + 3
end

firt_column_key = { A: '🪨', B: '🗒️', C: '✂️' }
second_column_key = { X: '🪨', Y: '🗒️', Z: '✂️' }
score = 0

File.readlines('input.txt', chomp: true).each do |line|
  round_array = line.split
  them = firt_column_key[round_array[0].to_sym]
  me = second_column_key[round_array[1].to_sym]
  score += calculate_score(them, me)
end

puts("part 1 #{score}")

def get_my_move(them, expected_result)
  defeats = { '🪨': '🗒️', '🗒️': '✂️', '✂️': '🪨' }

  return $is_defeated_by[them.to_sym] if expected_result == 'lose'

  return defeats[them.to_sym] if expected_result == 'win'

  them
end

second_column_key_fixed = { X: 'lose', Y: 'draw', Z: 'win' }
score2 = 0

File.readlines('input.txt', chomp: true).each do |line|
  round_array = line.split
  them = firt_column_key[round_array[0].to_sym]
  expected_result = second_column_key_fixed[round_array[1].to_sym]
  me = get_my_move(them, expected_result)
  score2 += calculate_score(them, me)
end

puts("part 2 #{score2}")
