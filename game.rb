require './map'
require './board'

module TomAndJerry

  class ConsoleGame
    attr_accessor :playground, :level, :over

    def initialize(playground, level, over)
      @playground = playground
      @level = level
      @over = over
    end

    def self.init_game(file_map, lives_left = Configurations::LIVES, current_score = 0)
      map = Map.parse(file_map)
      map.init_map
      file_map.match(/[a-z]+(\d\d)/)
      $1[0] == '0' ? l = $1[1].to_i : l = $1.to_i
      player = Jerry.new(*map.player, lives_left, current_score)
      playground = GameBoard.new(map.walls, map.targets, map.enemies, player)
      playground.set_walls
      playground.set_targets
      playground.set_enemies
      playground.set_player
      ConsoleGame.new(playground, l, false)
    end

    def player_move(player_direction)
      playground.jerry.choose_direction(player_direction)
    end

    def enemies_move
      player = playground.jerry
      new_enemies = playground.tom_group.map.with_index do |tom, i|
        if (i + 3) % 3 == 0
          move = tom.chaser_mode(player.x, player.y, player.direct_x, player.direct_y)
        else
          if level > 5
            move = tom.same_direction_mode(player.direct_x, player.direct_y)
          else
            move = tom.opposite_direction_mode(player.direct_x, player.direct_y)
          end
        end
        tom.move_validation(move, @playground.walls, @playground.targets)
      end
      new_enemies
    end

    def update_game(player, enemies)
      jerry = Jerry.new(*player, @playground.jerry.lives, @playground.jerry.score)
      board = GameBoard.new(@playground.walls, @playground.targets, enemies, jerry)
      board.set_walls
      board.set_targets
      board.set_enemies
      board.set_player
      if board.invalid
        puts "You are not supposed to cheat!"
        playground.jerry.unmark_position
        self
      elsif board.jerry.lives == 0
        puts "Game over!"
        return ConsoleGame.new(board, @level, true)
      elsif board.jerry.lost_life
        puts "You have #{board.jerry.lives} more lives!"
        ConsoleGame.init_game(Configurations::MAPS[level - 1], board.jerry.lives, board.jerry.score)
      elsif board.jerry.won
        puts "Next level!"
        ConsoleGame.init_game(Configurations::MAPS[level], board.jerry.lives, board.jerry.score)
      else
        ConsoleGame.new(board, @level, false)
      end
    end
  end

end
