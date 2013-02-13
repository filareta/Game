require 'minitest/unit'

class TestJerry < MiniTest::Unit::TestCase
  def setup
    @jerry = TomAndJerry::Jerry.new(5, 7)
    @left = @jerry.x - 1
    @right = @jerry.x + 1
    @down = @jerry.y + 1
    @up = @jerry.y - 1
  end

  def test_move_left
    jerry = TomAndJerry::Jerry.new(3, 1)
    jerry.move_left
    assert_equal -1, jerry.direct_x
    assert_equal [2, 1], jerry.mark_position
    @jerry.move_left
    assert_equal -1, @jerry.direct_x
    assert_equal [@left, @jerry.y], @jerry.mark_position
  end

  def test_move_right
    jerry = TomAndJerry::Jerry.new(1, 1)
    jerry.move_right
    assert_equal 1, jerry.direct_x
    assert_equal [2, 1], jerry.mark_position
    @jerry.move_right
    assert_equal 1, @jerry.direct_x
    assert_equal [@right, @jerry.y], @jerry.mark_position
  end

  def test_move_up
    jerry = TomAndJerry::Jerry.new(3, 1)
    jerry.move_up
    assert_equal -1, jerry.direct_y
    assert_equal [3, 0], jerry.mark_position
    @jerry.move_up
    assert_equal -1, @jerry.direct_y
    assert_equal [@jerry.x, @up], @jerry.mark_position
  end

  def test_move_down
    jerry = TomAndJerry::Jerry.new(2, 1)
    jerry.move_down
    assert_equal 1, jerry.direct_y
    assert_equal [2, 2], jerry.mark_position
    @jerry.move_down
    assert_equal 1, @jerry.direct_y
    assert_equal [@jerry.x, @down], @jerry.mark_position
  end

  def test_choose_direction
    @jerry.choose_direction("left")
    assert_equal [@left, @jerry.y], @jerry.mark_position
    assert_equal -1, @jerry.direct_x
    @jerry.choose_direction("right")
    assert_equal [@jerry.x, @jerry.y], @jerry.mark_position
    assert_equal 1, @jerry.direct_x
    @jerry.choose_direction("up")
    assert_equal [@jerry.x, @up], @jerry.mark_position
    assert_equal -1, @jerry.direct_y
    @jerry.choose_direction("down")
    assert_equal [@jerry.x, @jerry.y], @jerry.mark_position
    assert_equal 1, @jerry.direct_y
  end

end