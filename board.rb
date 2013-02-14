require './config_file'
require './map'
require './enemy'
require './player'
require './tests/test_board'

module TomAndJerry

  class GameBoard
    attr_accessor :board, :walls, :targets, :tom_group, :jerry, :invalid

    def initialize(walls, targets, tom_group, jerry)
      @board = Array.new(Configurations::MAP_SIZE_Y) { Array.new(Configurations::MAP_SIZE_X, '0') }
      @walls = walls
      @targets = targets
      @tom_group = tom_group.map { |(x, y)| Tom.new(x, y) }
      @jerry = jerry
      @invalid = false
    end

    def in_range?(x, y)
      x >= 0 and x < Configurations::MAP_SIZE_X and
      y >= 0 and y < Configurations::MAP_SIZE_Y and
      @board[y][x] == '0'
    end

    def set_walls
      @walls.each do |(x, y)|
        if in_range?(x, y) then @board[y][x] = '#' end
      end
    end

    def set_targets
      @targets.each do |(x, y)|
        if in_range?(x, y) then @board[y][x] = 'C' end
      end
    end

    def set_enemies
      @tom_group.each do |tom|
        if in_range?(tom.x, tom.y) then @board[tom.y][tom.x] = 'T' end
      end
    end

    def set_player
      if in_range?(@jerry.x, @jerry.y) then @board[@jerry.y][@jerry.x] = 'J' end
      if @board[@jerry.y][@jerry.x] == 'T'
        @jerry.lives -= 1
        @jerry.lost_life = true
      elsif @board[@jerry.y][@jerry.x] == 'C'
        @board[@jerry.y][@jerry.x] = 'J'
        @jerry.score += 50
        @targets.delete([@jerry.x, @jerry.y])
        if @targets.empty? then @jerry.won = true end
      elsif @board[@jerry.y][@jerry.x] == '#' then @invalid = true
      end
    end

    def draw
      @board.map{ |row| puts row.join(' ') }
    end
  end

end
