require 'minitest/unit'

class MapTest < MiniTest::Unit::TestCase
  EXPECTED = [%w[T # 0 0 T],
              %w[0 0 # 0 0],
              %w[0 0 J 0 #],
              %w[C 0 # 0 C]]
  WALLS = [[1, 0], [2, 1], [4, 2], [2, 3]]
  TARGETS = [[0, 3], [4, 3]]
  ENEMIES = [[0, 0], [4, 0]]

  def setup
    @map = TomAndJerry::Map.parse("test01.txt")
  end

  def test_parse
    assert_equal EXPECTED, @map.maze
  end

  def test_init_map
    @map.init_map
    assert_equal WALLS, @map.walls
    assert_equal TARGETS, @map.targets
    assert_equal ENEMIES, @map.enemies
    assert_equal [2, 2], @map.player
  end
end