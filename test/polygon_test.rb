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

  # def teardown
  # end

  def test_types_are_set
    assert_equal true, @triangle.inside?(@square)
    assert_equal false, @square.inside?(@triangle)
    assert_equal false, @rectangle.inside?(@square)
    
    assert_equal true, @square.has_point_inside?(Geometry::Point.new(1,1))
  end
  
  def test_run_program
    Geometry::View.new.print_statistics(@polygons)
  end
end
