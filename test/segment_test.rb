$LOAD_PATH.unshift File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib')
$LOAD_PATH.unshift File.join(File.dirname(File.expand_path(__FILE__)))

require 'segment'

class SegmentTest < Test::Unit::TestCase
  def setup
    @s1 = Geometry::Segment.new_by_arrays([0,10], [10, 10])
    @s2 = Geometry::Segment.new_by_arrays([3,12], [5, 8])
    @s3 = Geometry::Segment.new_by_arrays([-1,-10], [-1, -20])
  end
  
  def test_intersection
    assert_equal true, @s1.intersects_with?(@s2)
    assert_equal false, @s1.intersects_with?(@s3)
  end
  
  def test_find_intersection_point
    # precision??
    assert_equal 10.0, @s1.find_intersection_point_with(@s2).y
    assert_equal 4.0, @s1.find_intersection_point_with(@s2).x
  end
end