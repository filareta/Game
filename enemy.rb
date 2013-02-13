require './movements'
require './direction'
require './tests/test_enemy'
require './config_file'

module TomAndJerry

  class Tom
    include MovementModes
    include Direction

    attr_accessor :x, :y, :direct_x, :direct_y

    def initialize(x, y)
      @x = x
      @y = y
      @direct_x = 0
      @direct_y = 0
    end

    def move_left
      @x -= 1
      @direct_x = -1
      @direct_y = 0
    end

    def move_up
      @y -= 1
      @direct_y = -1
      @direct_x = 0
    end

    def move_down
      @y += 1
      @direct_y = 1
      @direct_x = 0
    end

    def move_right
      @x += 1
      @direct_x = 1
      @direct_y = 0
    end

    def mark_position
      [@x, @y]
    end
  end

end
