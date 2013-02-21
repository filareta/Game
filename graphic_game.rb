require 'rubygems'
require 'rubygame'
require './config_file'
require './enemy'
require './map'
require './player'
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

  MOVES = [K_LEFT, K_RIGHT, K_UP, K_DOWN]

  class EnemyGraphics
    include Sprites::Sprite

    SPEED = 60

    def initialize(enemy)
      @enemy = enemy
      @image = Surface['tom.jpg']
      @rect = @image.make_rect
      @rect.center = [enemy.x * Configurations::SCALE + Configurations::SCALE / 2,
                      enemy.y * Configurations::SCALE + Configurations::SCALE / 2]
    end

    def keep_in_bounds(walls, targets)
      if @rect.collide_rect?(SCREEN_BOUNDS[:right]) then @rect.right = 640
      elsif @rect.collide_rect?(SCREEN_BOUNDS[:left]) then @rect.left = 0
      elsif @rect.collide_rect?(SCREEN_BOUNDS[:top]) then @rect.top = 0
      elsif @rect.collide_rect?(SCREEN_BOUNDS[:bottom]) then @rect.bottom = 480
      end
      walls.each do |wall|
        if @rect.collide_rect? wall
          if @enemy.direct_x == 1 then @rect.right -= 5
          elsif @enemy.direct_x == -1 then @rect.left += 5
          elsif @enemy.direct_y == 1 then @rect.bottom -= 5
          elsif @enemy.direct_y == -1 then @rect.top += 5
          end
        end
      end
      targets.each do |target|
        if @rect.collide_rect? target
          if @enemy.direct_x == 1 then @rect.right -= 5
          elsif @enemy.direct_x == -1 then @rect.left += 5
          elsif @enemy.direct_y == 1 then @rect.bottom -= 5
          elsif @enemy.direct_y == -1 then @rect.top += 5
          end
        end
      end
    end

    def update(delta, i, player, level, walls, targets)
      keep_in_bounds(walls, targets)
      if collide_sprite? player
        player.jerry.lost_life = true
        if player.jerry.lives > 0 then player.jerry.lives -= 1 end
      end
      dir_x = dir_y = 0
      if player.direction == 'left' then dir_x = -1
      elsif player.direction == 'right' then dir_x = 1
      elsif player.direction == 'up' then dir_y = -1
      elsif player.direction == 'down' then dir_y = 1
      end
      if (i + 3) % 3 == 0
        move = @enemy.chaser_mode(player.jerry.x, player.jerry.y, dir_x, dir_y)
      else
        if level > 5
          move = @enemy.same_direction_mode(dir_x, dir_y)
        else
          move = @enemy.opposite_direction_mode(dir_x, dir_y)
        end
      end
      update_direction(delta)
    end

    def update_direction(delta)
      @rect.centerx += SPEED * delta * @enemy.direct_x
      @rect.centery += SPEED * delta * @enemy.direct_y
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
      @rect.center = [player.x * Configurations::SCALE + Configurations::SCALE / 2,
                      player.y * Configurations::SCALE + Configurations::SCALE / 2]
    end

    def events(event)
      case event
      when KeyDownEvent
        case event.key
        when K_LEFT
          @jerry.choose_direction('left')
          @direction = 'left'
        when K_RIGHT
          @jerry.choose_direction('right')
          @direction = 'right'
        when K_UP
          @jerry.choose_direction('up')
          @direction = 'up'
        when K_DOWN
          @jerry.choose_direction('down')
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

    def update(delta, walls, targets)
      @rect.centerx += SPEED * delta * @jerry.direct_x
      @rect.centery += SPEED * delta * @jerry.direct_y
      if @rect.collide_rect?(SCREEN_BOUNDS[:right]) then @rect.right = 640
      elsif @rect.collide_rect?(SCREEN_BOUNDS[:left]) then @rect.left = 0
      elsif @rect.collide_rect?(SCREEN_BOUNDS[:top]) then @rect.top = 0
      elsif @rect.collide_rect?(SCREEN_BOUNDS[:bottom]) then @rect.bottom = 480
      end
      walls.each do |wall|
        if @rect.collide_rect? wall
          if @jerry.direct_x == 1 then @rect.right -= 10
          elsif @jerry.direct_x == -1 then @rect.left += 10
          elsif @jerry.direct_y == 1 then @rect.bottom -= 10
          elsif @jerry.direct_y == -1 then @rect.top += 10
          end
        end
      end
      targets.each do|target|
        if @rect.collide_rect? target
          @jerry.score += 50
          targets.delete(target)
        end
      end
      if targets.empty? then @jerry.won = true end
    end
  end

  class GraphicGame
    attr_accessor :player, :targets, :enemies, :walls, :level, :over, :won

    def initialize(player, targets, enemies, walls, level, over)
      @player = player
      @targets = targets
      @enemies = enemies
      @walls = walls
      @level = level
      @over = over
      @won = false
    end
  end

  class GraphicWindow
    attr_accessor :screen, :queue, :clock, :game_over, :graphic_enemies, :graphic_player, :winner

    def initialize
      @screen = Screen.new [Configurations::SCREEN_SIZE_X, Configurations::SCREEN_SIZE_Y]
      @screen.title = "Tom and Jerry"
      @queue = EventQueue.new
      @clock = Clock.new
      @clock.target_framerate = Configurations::FRAMERATE
      @wall = Surface['brick.jpg']
      @target = Surface['cheese.png']
      @game_over = Surface['game_over.jpg']
      @winner = Surface['winner.jpg']
      @graphic_enemies = []
    end

    def draw_playground(walls, targets)
      @screen.fill [255, 255, 255]
      walls.each { |(x, y)| @wall.blit(@screen, [x, y]) }
      targets.each { |(x, y)| @target.blit(@screen, [x, y]) }
    end

    def set_walls(walls)
      walls.map do |(x, y)|
        Rect.new(x * Configurations::SCALE, y * Configurations::SCALE,
                Configurations::WALL_X, Configurations::WALL_Y)
      end
    end

    def set_targets(targets)
      targets.map do |(x, y)|
        Rect.new(x * Configurations::SCALE, y * Configurations::SCALE,
                Configurations::SCALE, Configurations::SCALE)
      end
    end

    def set_enemies(enemies)
      @graphic_enemies = enemies.map { |enemy| EnemyGraphics.new enemy }
    end

    def set_player(player)
      @graphic_player = PlayerGraphic.new player
    end

    def load(file_map, lives_left = Configurations::LIVES, current_score = 0)
      map = Map.parse(file_map)
      map.init_map
      file_map.match(/[a-z]+(\d\d)/)
      $1[0] == '0' ? l = $1[1].to_i : l = $1.to_i
      player = Jerry.new(*map.player, lives_left, current_score)
      enemies = map.enemies.map { |(x, y)| Tom.new(x, y) }
      game_walls = set_walls(map.walls)
      game_targets = set_targets(map.targets)
      if player.lives == 0
        GraphicGame.new(player, game_targets, enemies, game_walls, l, true)
      else
        GraphicGame.new(player, game_targets, enemies, game_walls, l, false)
      end
    end

    def update(event, game, player)
      case event
      when KeyDownEvent
        case event.key
        when K_RSHIFT
          game = load(Configurations::MAPS[0])
          set_enemies(game.enemies)
          set_player(game.player)
        end
      end
      if player.won
        if game.level == Configurations::LEVELS_NUMBER
          game.won = true
        else
          game = load(Configurations::MAPS[game.level], player.lives, player.score)
          set_enemies(game.enemies)
          set_player(game.player)
        end
      elsif player.lost_life
        game = load(Configurations::MAPS[game.level - 1], player.lives, player.score)
        set_enemies(game.enemies)
        set_player(game.player)
      end
      game
    end

    def main_loop
      game = load(Configurations::MAPS[0])
      set_enemies(game.enemies)
      set_player(game.player)
      loop do
        delta = clock.tick * 0.001
        queue.each do |event|
          return if event.is_a? QuitEvent
          graphic_player.events event
          game = update event, game, graphic_player.jerry
        end
        if game.over
          game_over.blit(screen, [0, 0])
          screen.update
        elsif game.won
          winner.blit(screen, [0, 0])
          screen.update
        else
          graphic_player.update delta, game.walls, game.targets
          graphic_enemies.each.with_index do |enemy, i|
            enemy.update(delta, i, graphic_player, game.level, game.walls, game.targets)
          end
          draw_playground(game.walls, game.targets)
          graphic_player.draw screen
          graphic_enemies.each { |enemy| enemy.draw screen }
          screen.update
        end
      end
    end
  end

  GraphicWindow.new.main_loop

end