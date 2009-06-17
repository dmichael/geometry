require 'rexml/document'
require 'shape'
require 'point'


class Geometry
  attr_accessor :shapes
  
  def initialize(xml)
    @shapes = []
    parse_xml(xml)
  end
  
  def parse_xml(xml)
    doc = REXML::Document.new(xml)
    
    doc.elements.each('geometry/shape') do |shape|
      @shapes << Shape.new(shape.attributes['id'])
        
      shape.elements.each do |point|
        @shapes.last.points << Point.new(point.attributes['x'], point.attributes['y'])
      end
    end    
  end
end

geometry = Geometry.new(File.read('test/geometry.xml'))


geometry.shapes.each do |shape|
  puts shape.convex?

  #puts shape.angles.inspect
  puts ''
end

=begin
polygon-polygon intersect

The edges are line segments, so you have two sets of line segments, one
for each poly. If any line segment in one of the sets crosses any of the
line segments in the other set, then the polygons intersect. Otherwise
they don't.

So:

foreach a in A:
foreach b in B:
if a intersects b: return true
return false

is your basic program

Then all you have to worry about is how to intersect two linesegments,
which isn't too hard.

Some of the algorithms for convex polygons are more sophisticated,
basically because you can do some clever optimizations on this nested
loop based on the fact that they're convex.




http://local.wasp.uwa.edu.au/~pbourke/geometry/insidepoly/
http://www.dfanning.com/tips/point_in_polygon.html



bool PolyPolyIntersection( Polygon PolyA, Polygon PolyB )
{
	if( !Poly[ A ].size() || !Poly[ B ].size() )
		return false; //Be sure that these polygons actually have verticies on them

	//Check each segment on polyB for intersection with each segment of PolyB
	int pA0 = polyA.size() - 1;
	int pA1 = 0;
	do
	{

		int pB0 = polyB.size() - 1;
		int pB1 = 0;
		do
		{
			if( SegmentSegmentIntersection( polyA[ pA0 ], polyA[ pA1 ], polyB[ pB0 ], polyB[ pB1 ] ) )
				return true;

			pB0 = pB1;
			pB1++;
		}
		while( pB1 < polyB.size() );


		pA0 = pA1;
		pA1++;
	}
	while( pA1 < polyA.size() );

	//Determine if one polygon lies entierly within the other
	if( PointInPoly( polyA[ 0 ], polyB || PointInPoly( polyB[ 0 ], polyA )
		return true;

	return false;
}

=end

