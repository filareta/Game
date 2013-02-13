module TomAndJerry

  module MovementModes
    def chaser_mode(target_x, target_y, dir_x, dir_y)
      if target_x == x  and target_y != y
        if target_y < y
          move_up
        else
          move_down
        end
      elsif target_y == y and target_x != x
        if target_x < x
          move_left
        else
          move_right
        end
      elsif dir_y == 0 and target_x > x then move_right
      elsif dir_y == 0 and target_x < x then move_left
      elsif dir_x == 0 and target_y > y then move_down
      elsif dir_x == 0 and target_y <  y then move_up
      end
      mark_position
    end

    def opposite_direction_mode(target_direct_x, target_direct_y)
      if target_direct_x == 1 then move_left
      elsif target_direct_x == -1 then move_right
      elsif target_direct_y == 1 then move_up
      elsif target_direct_y == -1 then move_down
      end
      mark_position
    end

    def same_direction_mode(target_direct_x, target_direct_y)
      if target_direct_x == 1 then move_right
      elsif target_direct_x == -1 then move_left
      elsif target_direct_y == 1 then move_down
      elsif target_direct_y == -1 then move_up
      end
      mark_position
    end

    def random_move(walls, targets)
     [ [0, 1, "down"], [-1, 0, "left"], [1, 0, "right"], [0, -1, "up"]].each do |(a, b, direction)|
      a += self.x
      b += self.y
      if valid_move? a, b, walls, targets
       return choose_direction(direction)
      end
     end
    end

    def valid_move?(m, n, walls, targets)
      m >= 0 and m < Configurations::MAP_SIZE_X and
      n >= 0 and n < Configurations::MAP_SIZE_Y and
      walls.map { |(a, b)| a != m or b != n }.all? and
      targets.map { |(a, b)| a != m or b != n }.all?
    end

    def move_validation(move, walls, targets)
      if valid_move?(move[0], move[1], walls, targets)
        move
      else
        unmark_position
        random_move(walls, targets)
      end
    end
  end

end
