require './game'

module TomAndJerry

  class GameLoop
    def self.main_loop
      puts "Type exit to quit the game or new to restart it!"
      game = ConsoleGame.init_game(Configurations::MAPS[0])
      loop do
        game.playground.draw
        puts "Choose direction! Enter left, right, up or down.\n"
        STDOUT.flush
        command = gets.chomp
        return if command == 'exit'
        if command == 'new'
          game = ConsoleGame.init_game(Configurations::MAPS[0])
        else
          if Configurations::DIRECTIONS.include? command
            new_player = game.player_move(command)
            new_enemies = game.enemies_move
            game = game.update_game(new_player, new_enemies)
          else
            puts "Invalid command! Try again!"
            next
          end
        end
        return if game.over
        if Configurations::MAPS.empty?
          puts "Congratulations! You win!"
          return
        end
      end
    end
  end

GameLoop.main_loop

end