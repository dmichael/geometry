require 'test/unit'

class GeometryTest < Test::Unit::TestCase
  def test_module_functions
    xml  = File.read(File.join(File.dirname(__FILE__), 'geometry.xml'))

    @polygons = Geometry.polygons_from_xml(xml)
    assert_equal 5, @polygons.size
  end
end