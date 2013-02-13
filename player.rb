require './tests/test_player'
require './direction'
require './config_file'

module TomAndJerry

  class Jerry
    include Direction
    attr_accessor :x, :y, :direct_x, :direct_y, :score, :lives, :won, :lost_life

    def initialize(x, y, lives = Configurations::LIVES, score = 0)
      @x = x
      @y = y
      @direct_x = 0
      @direct_y = 0
      @score = score
      @lives = lives
      @won = false
      @lost_life = false
    end

    def move_left
      @x -= 1
      @direct_x = -1
    end

    def move_up
      @y -= 1
      @direct_y = -1
    end

    def move_down
      @y += 1
      @direct_y = 1
    end

    def move_right
      @x += 1
      @direct_x = 1
    end

    def mark_position
      [@x, @y]
    end
  end

end