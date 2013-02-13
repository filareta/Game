module TomAndJerry
  module Direction
    def choose_direction(direction)
      case direction
      when "left" then move_left
      when "right" then move_right
      when "up" then move_up
      when "down" then move_down
      end
      mark_position
    end

    def unmark_position
      if @direct_x == -1
        @x += 1
        @direct_x = 0
      end
      if @direct_x == 1
        @x -= 1
        @direct_x = 0
      end
      if @direct_y == -1
        @y += 1
        @direct_y = 0
      end
      if @direct_y == 1
        @y -= 1
        @direct_y = 0
      end
      mark_position
    end
  end
end