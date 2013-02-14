require 'minitest/unit'

class TestConsoleGame < MiniTest::Unit::TestCase
  WALLS = [[1, 0], [2, 1], [4, 2], [2, 3]]
  TARGETS = [[0, 3], [4, 3]]
  ENEMIES = [[0, 0], [4, 0]]

  def setup
    @game = TomAndJerry::ConsoleGame.init_game("test01.txt")
  end

  def test_init_game
    assert_equal 1, @game.level
    assert_equal WALLS, @game.playground.walls
    assert_equal TARGETS, @game.playground.targets
    ENEMIES.each.with_index do |(x, y), i|
      assert_equal x, @game.playground.tom_group[i].x
      assert_equal y, @game.playground.tom_group[i].y
    end
    player = TomAndJerry::Jerry.new(2, 2)
    assert_equal player.x, @game.playground.jerry.x
    assert_equal player.y, @game.playground.jerry.y
  end

  def test_player_move
    @game.player_move("right")
    assert_equal [3, 2], @game.playground.jerry.mark_position
    assert_equal 1, @game.playground.jerry.direct_x
  end

  def test_enemies_move
    @game.player_move("right")
    assert_equal [[0, 1], [3, 0]], @game.enemies_move
    assert_equal 0, @game.playground.tom_group[0].direct_x
    assert_equal 1, @game.playground.tom_group[0].direct_y
    assert_equal -1, @game.playground.tom_group[1].direct_x
    assert_equal 0, @game.playground.tom_group[1].direct_y
    @game.player_move("left")
    assert_equal [[1, 1], [4, 0]], @game.enemies_move
  end

  def test_update_game
    player = @game.player_move("right")
    updated = @game.update_game(player, @game.enemies_move)
    assert_equal WALLS, updated.playground.walls
    assert_equal [3, 2], updated.playground.jerry.mark_position
    assert_equal [0, 1], updated.playground.tom_group[0].mark_position
    example = updated.update_game(updated.player_move("right"), updated.enemies_move)
    assert_equal [3, 2], example.playground.jerry.mark_position
    assert_equal updated, example
    game = TomAndJerry::ConsoleGame.init_game("test01.txt", 0)
    assert_equal true, game.update_game(player, game.enemies_move).over
    expected = @game.update_game(player, [[1, 1], [3, 2]])
    assert_equal 2, expected.playground.jerry.lives
  end


end
