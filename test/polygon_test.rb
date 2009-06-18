$LOAD_PATH.unshift File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib')
$LOAD_PATH.unshift File.join(File.dirname(File.expand_path(__FILE__)))

require 'geometry'
require 'test/unit'

class PolygonTest < Test::Unit::TestCase
  def setup
    @polygons  = Geometry.polygons_from_xml(File.read('test/geometry.xml'))
    
    @square    = @polygons[0]
    @odd       = @polygons[1]
    @triangle  = @polygons[2]
    @rectangle = @polygons[3]
    @pentagon  = @polygons[4]    
  end
  
  def test_types_are_set
    # is this really necessary?
    assert_equal 'triangle', @triangle.type
    assert_equal 'square', @square.type
  end
  
  def test_odd_convexity
    assert_equal(false, @odd.convex?)
  end
  
  def test_square_convexity
    assert_equal(true, @square.convex?)
  end
  
  def test_random_polygon_convexity
    points = [
      Geometry::Point.new(0,0),
      Geometry::Point.new(1,0),
      Geometry::Point.new(2,0),
      Geometry::Point.new(6,-1),
      Geometry::Point.new(4,5)
    ]
    assert_equal(false, Geometry::Polygon.new(points).convex?)
    
    points = [
      Geometry::Point.new(1,1),
      Geometry::Point.new(1,2),
      Geometry::Point.new(2,2),
      Geometry::Point.new(2,1)
    ]
    assert_equal(true, Geometry::Polygon.new(points).convex?)
    assert_equal('ConvexCW', Geometry::Polygon.new(points).convexity)
  end
  
  def test_interior_points
    assert_equal true, @square.has_interior_point?(Geometry::Point.new(1,1))
    # this is an edge case :(
    assert_equal false, @square.has_interior_point?(Geometry::Point.new(0,0))
    assert_equal false, @square.has_interior_point?(Geometry::Point.new(-1,1))
    assert_equal true, @square.has_interior_point?(Geometry::Point.new(10,10))
  end
  
  def test_intersections
    assert_equal false, @square.intersects_with?(@triangle)
    assert_equal true, @square.intersects_with?(@rectangle)
  end
  
  def test_insiders
    assert_equal true, @triangle.inside?(@square)
    assert_equal false, @triangle.inside?(@rectangle)
  end
  
  def test_surrounders
    assert_equal false, @triangle.surrounds?(@square)
    assert_equal true, @square.surrounds?(@triangle)
  end
  
  def test_run_program
    Geometry::View.new.render(:polygons => @polygons)
  end
end
