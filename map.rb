require './tests/test_map'
require './config_file'

module TomAndJerry

  class Map
    attr_accessor :maze, :walls, :targets, :enemies, :player

    def initialize(matrix)
      @maze = matrix
      @walls = []
      @enemies = []
      @targets = []
    end

    def self.parse(filename)
      file = File.absolute_path("data/#{filename}")
      input = File.open(file)
      file_map = input.each_line.map { |s| s.split }
      input.close
      Map.new file_map
    end

    def init_map
      @maze.each.with_index do |row, i|
        row.each.with_index do |item, j|
          if item == '#'
            @walls << [j, i]
          elsif item == 'C'
            @targets << [j, i]
            @maze[i][j] = 'C'
          elsif item == 'T'
            @enemies << [j, i]
            @maze[i][j] = 'T'
          elsif item == 'J'
            @player = [j, i]
            @maze[i][j] = 'J'
          end
        end
      end
    end
  end

end