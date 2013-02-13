require 'minitest/unit'

class TestTom < MiniTest::Unit::TestCase
  def setup
    @tom = TomAndJerry::Tom.new(3, 5)
    @left = @tom.x - 1
    @right = @tom.x + 1
    @up = @tom.y - 1
    @down = @tom.y + 1
    @start = [@tom.x, @tom.y]
  end

  def test_mark_position
    assert_equal @start, @tom.mark_position
  end

  def test_move_left
    @tom.move_left
    assert_equal -1, @tom.direct_x
    assert_equal @left, @tom.x
    assert_equal [@left, @tom.y], @tom.mark_position
    assert_equal @start, @tom.unmark_position
  end

  def test_move_right
    @tom.move_right
    assert_equal 1, @tom.direct_x
    assert_equal @right, @tom.x
    assert_equal [@right, @tom.y], @tom.mark_position
    assert_equal @start, @tom.unmark_position
  end

  def test_move_up
    @tom.move_up
    assert_equal -1, @tom.direct_y
    assert_equal @up, @tom.y
    assert_equal [@tom.x, @up], @tom.mark_position
    assert_equal @start, @tom.unmark_position
  end

  def test_move_down
    @tom.move_down
    assert_equal 1, @tom.direct_y
    assert_equal @down, @tom.y
    assert_equal [@tom.x, @down], @tom.mark_position
    assert_equal @start, @tom.unmark_position
  end

  def test_unmark_position
    @tom.move_left
    assert_equal @start, @tom.unmark_position
    @tom.move_right
    assert_equal @start, @tom.unmark_position
    @tom.move_up
    assert_equal @start, @tom.unmark_position
    @tom.move_down
    assert_equal @start, @tom.unmark_position
  end

  def test_same_direction_mode
    assert_equal [@tom.x - 1, @tom.y], @tom.same_direction_mode(-1, 0)
    assert_equal [@tom.x + 1, @tom.y], @tom.same_direction_mode(1, 0)
    assert_equal [@tom.x, @tom.y - 1], @tom.same_direction_mode(0, -1)
    assert_equal [@tom.x, @tom.y + 1], @tom.same_direction_mode(0, 1)
  end

  def test_opposite_direction_mode
    assert_equal [@tom.x + 1, @tom.y], @tom.opposite_direction_mode(-1, 0)
    assert_equal [@tom.x - 1, @tom.y], @tom.opposite_direction_mode(1, 0)
    assert_equal [@tom.x, @tom.y + 1], @tom.opposite_direction_mode(0, -1)
    assert_equal [@tom.x, @tom.y - 1], @tom.opposite_direction_mode(0, 1)
  end

  def test_chaser_mode
    assert_equal [@tom.x - 1, @tom.y], @tom.chaser_mode(1, 3, 1, 0)
    assert_equal [@tom.x + 1, @tom.y], @tom.chaser_mode(5, 3, -1, 0)
    assert_equal [@tom.x, @tom.y + 1], @tom.chaser_mode(2, 6, 0, -1)
    assert_equal [@tom.x, @tom.y - 1], @tom.chaser_mode(2, 3, 0, 1)
    assert_equal [@tom.x, @tom.y + 1], @tom.chaser_mode(3, 7, 0, -1)
    assert_equal [@tom.x, @tom.y - 1], @tom.chaser_mode(3, 2, 1, 0)
    assert_equal [@tom.x + 1, @tom.y], @tom.chaser_mode(5, 5, 0, -1)
    assert_equal [@tom.x - 1, @tom.y], @tom.chaser_mode(1, 5, 1, 0)
  end

  def test_valid_move?
    walls = [[2, 3], [5, 7], [0, 11]]
    targets = [[6, 8], [11, 12]]
    assert_equal true, @tom.valid_move?(2, 8, walls, targets)
    assert_equal false, @tom.valid_move?(5, 7, walls, targets)
    assert_equal false, @tom.valid_move?(58, 6, walls, targets)
  end

  def test_move_validation
    walls = [[2, 3], [5, 7], [0, 11]]
    targets = [[6, 8], [11, 12]]
    assert_equal [2, 8], @tom.move_validation([2, 8], walls, targets)
    enemy = TomAndJerry::Tom.new(4, 7)
    enemy.move_right
    move = enemy.mark_position
    assert_equal [4, 8], enemy.move_validation(move, walls, targets)
  end

  def test_random_move
    walls = [[2, 3], [5, 7], [4, 8], [0, 11]]
    targets = [[6, 8], [11, 12]]
    { TomAndJerry::Tom.new(4, 7) => [3, 7],
      TomAndJerry::Tom.new(6, 7) => [7, 7] }.each do |(example, answer)|
    assert_equal answer, example.random_move(walls, targets)
    end
  end
end