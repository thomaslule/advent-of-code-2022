# frozen_string_literal: true

def four_different?(str)
  str.length == 4 && str.chars.uniq.length == 4
end

def fourteen_different?(str)
  str.length == 14 && str.chars.uniq.length == 14
end

if __FILE__ == $PROGRAM_NAME
  input = File.read("input.txt", chomp: true)
  position = 3
  marker = ""
  until four_different?(marker)
    position += 1
    marker = input.slice(position - 4..position - 1)
  end
  puts "part 1 #{position}"
  position = 13
  marker = ""
  until fourteen_different?(marker)
    position += 1
    marker = input.slice(position - 14..position - 1)
  end
  puts "part 2 #{position}"
end
