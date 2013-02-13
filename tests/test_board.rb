require 'minitest/unit'

class TestGameBoard < MiniTest::Unit::TestCase
  EXPECTED = [%w[T # 0 0 T],
              %w[0 0 # 0 0],
              %w[0 0 J 0 #],
              %w[C 0 # 0 C]]
  WALLS = [[1, 0], [2, 1], [4, 2], [2, 3]]
  TARGETS = [[0, 3], [4, 3]]
  ENEMIES = [[0, 0], [4, 0]]

  def setup
    @player = TomAndJerry::Jerry.new(2, 2)
    @playground = TomAndJerry::GameBoard.new(WALLS, TARGETS, ENEMIES, @player)
  end

  def test_in_range?
    assert_equal true, @playground.in_range?(3, 1)
    assert_equal false, @playground.in_range?(90, -2)
    assert_equal false, @playground.board.nil?
  end

  def test_set_walls
    @playground.set_walls
    WALLS.each { |(x, y)| assert_equal '#', @playground.board[y][x] }
  end

  def test_set_targets
    @playground.set_targets
    TARGETS.each { |(x, y)| assert_equal 'C', @playground.board[y][x] }
  end

  def test_set_enemies
    @playground.set_enemies
    ENEMIES.each { |(x, y)| assert_equal 'T', @playground.board[y][x] }
  end

  def test_set_player
    @playground.set_player
    assert_equal 'J', @playground.board[@player.y][@player.x]
    { [jerry = TomAndJerry::Jerry.new(4, 0, 2),
      TomAndJerry::GameBoard.new(WALLS, TARGETS, ENEMIES, jerry)] => [1, true, 0, TARGETS, false, false],
      [jerry = TomAndJerry::Jerry.new(0, 3),
      TomAndJerry::GameBoard.new(WALLS, TARGETS, ENEMIES, jerry)] => [jerry.lives, false, 50, [[4, 3]], false, false],
      [jerry = TomAndJerry::Jerry.new(4, 3),
      TomAndJerry::GameBoard.new(WALLS, [[4, 3]], ENEMIES, jerry)] => [jerry.lives, false, 50, [], true, false],
      [jerry = TomAndJerry::Jerry.new(2, 1),
      TomAndJerry::GameBoard.new(WALLS, TARGETS, ENEMIES, jerry)] => [jerry.lives, false, 0, TARGETS, false, true]
    }.each do |(a, b), (lives, lost, score, target, won, invalid)|
        b.set_walls
        b.set_targets
        b.set_enemies
        b.set_player
        assert_equal lives, b.jerry.lives
        assert_equal lost, b.jerry.lost_life
        assert_equal score, b.jerry.score
        assert_equal target, b.targets
        assert_equal won, b.jerry.won
        assert_equal invalid, b.invalid
      end
  end

end