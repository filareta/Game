require 'rubygems'
require 'rubygame'
require './config_file'
require './enemy'
require './map'
require './player'
require './game'
include Rubygame

module TomAndJerry

  resources_dir = File.dirname( __FILE__ ) + "/images"
  Surface.autoload_dirs = [ resources_dir ]

  SCREEN_BOUNDS = {
    :left => Rect.new( [-100, 0, 100, 480] ),
    :right => Rect.new( [640, 0, 100, 480] ),
    :top => Rect.new( [0, -100, 640, 100] ),
    :bottom => Rect.new( [0, 480, 640, 100] )
    }

  class EnemyGraphics
    include Sprites::Sprite

    SPEED = 60

    def initialize(enemies)
      @enemies = enemies.map do |enemy|
        @enemy = enemy
        @image = Surface['tom.jpg']
        @rect = @image.make_rect
        @rect.center = [enemy.x, enemy.y]
      end
    end

    def update(delta, game)
      game.enemies_move(Configurations::SCALE)
    end

    def update_direction(delta)
      @enemies.each do |enemy|
        @rect.centerx += SPEED * delta * @enemy.direct_x
        @rect.centery += SPEED * delta * @enemy.direct_y
      end
    end
  end

  class PlayerGraphic
    include Sprites::Sprite
    attr_accessor :jerry, :direction

    SPEED = 80

    def initialize(player)
      @jerry = player
      @image = Surface['jerry.jpg']
      @rect = @image.make_rect
      @rect.center = [player.x, player.y]
    end

    def events(event)
      case event
      when KeyDownEvent
        case event.key
        when K_LEFT
          @jerry.choose_direction('left', Configurations::SCALE)
          @direction = 'left'
        when K_RIGHT
          @jerry.choose_direction('right', Configurations::SCALE)
          @direction = 'right'
        when K_UP
          @jerry.choose_direction('up', Configurations::SCALE)
          @direction = 'up'
        when K_DOWN
          @jerry.choose_direction('down', Configurations::SCALE)
          @direction = 'down'
        end
      when KeyUpEvent
        case event.key
        when K_LEFT then @jerry.direct_x += 1
        when K_RIGHT then @jerry.direct_x -= 1
        when K_UP then @jerry.direct_y += 1
        when K_DOWN then @jerry.direct_y -= 1
        end
      end
    end

    def update(delta, walls)
      @rect.centerx += SPEED * delta * @jerry.direct_x
      @rect.centery += SPEED * delta * @jerry.direct_y
    end
  end

  class GraphicWindow
    attr_accessor :screen, :queue, :clock

    def initialize
      @screen = Screen.new [Configurations::SCREEN_SIZE_X, Configurations::SCREEN_SIZE_Y]
      @screen.title = "Tom and Jerry"
      @queue = EventQueue.new
      @clock = Clock.new
      @clock.target_framerate = Configurations::FRAMERATE
      @wall = Surface['brick.jpg']
      @target = Surface['cheese.png']
    end

    def draw_playground(walls, targets)
      @screen.fill [255, 255, 255]
      walls.each { |(x, y)| @wall.blit(@screen, [x, y]) }
      targets.each { |(x, y)| @target.blit(@screen, [x, y]) }
    end

    def update(player, enemies, game)
      game.update_game(player, enemies, Configurations::SCALE)
    end


    def main_loop
      game = ConsoleGame.init_game(Configurations::MAPS[0], Configurations::LIVES, 0,
                                   Configurations::SCALE,
                                  Configurations::SCREEN_SIZE_X, Configurations::SCREEN_SIZE_Y)
      enemies = EnemyGraphics.new game.playground.tom_group
      player = PlayerGraphic.new game.playground.jerry
      loop do
        delta = clock.tick * 0.001
        queue.each do |event|
          return if event.is_a? QuitEvent
          player.events event
        end
        player.update delta, game
        new_enemies = enemies.update delta, game
        game = update(player.jerry.mark_position,new_enemies, game)
        draw_playground(game.walls, game.targets)
        player.draw screen
        enemies.draw screen
        screen.update
        return if game.over
      end
    end
  end

  GraphicWindow.new.main_loop

end