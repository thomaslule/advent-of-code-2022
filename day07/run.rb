# frozen_string_literal: true

class Folder
  attr_accessor :name, :parent, :size, :children_folders, :children_files

  def initialize(name, parent = nil)
    @name = name
    @parent = parent
    @size = 0
    @children_folders = []
    @children_files = []
  end

  def increment_size(size)
    @size += size
    parent&.increment_size(size)
  end
end

class File
  def initialize(name, parent, size)
    @name = name
    @parent = parent
    @size = size
    parent.increment_size(size)
  end
end

class Explorer
  attr_accessor :sum, :smallest_bigenough

  def initialize(needed, biggest)
    @needed = needed
    @sum = 0
    @smallest_bigenough = biggest
  end

  def explore(folder)
    @sum += folder.size if folder.size <= 100_000
    @smallest_bigenough = folder.size if folder.size < @smallest_bigenough && folder.size > @needed
    folder.children_folders.each { |child| explore(child) }
  end
end

if __FILE__ == $PROGRAM_NAME
  root = Folder.new("/")
  current_folder = root
  File.readlines("input.txt", chomp: true).each do |line|
    if line.start_with?("$")
      if line == "$ cd /"
        current_folder = root
      elsif line == "$ cd .."
        current_folder = current_folder.parent
      elsif line.start_with?("$ cd")
        name = line.split[2]
        current_folder = current_folder.children_folders.find { |child| child.name == name }
      end
    elsif line.start_with?("dir")
      name = line.split[1]
      current_folder.children_folders.push(Folder.new(name, current_folder))
    else
      size, name = line.split
      current_folder.children_files.push(File.new(name, current_folder, size.to_i))
    end
  end

  needed_space = 30_000_000 - 70_000_000 + root.size

  explorer = Explorer.new(needed_space, root.size)
  explorer.explore(root)
  puts "part 1 #{explorer.sum}"
  puts "part 2 #{explorer.smallest_bigenough}"
end
