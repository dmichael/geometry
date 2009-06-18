require 'core_extensions'
require 'polygon_classifier'

module Geometry
  class Polygon
    attr_accessor :type, :points, :segments

    def initialize(points = [], options = {})
      @type     = options[:type] || 'Unknown'
      @points   = points || []
      @segments = []      
      # let create some segments for use elsewhere
      create_segments if @points.size >= 2
    end
    
    # This should maybe be private
    def create_segments
      @points.each_cycle(1) { |points| @segments << Segment.new(*points) }
    end

    def convex?
      polygon_classifier = PolygonClassifier.new(@points)
      (polygon_classifier.convexity != 'NotConvex') ? true : false
    end
    
    # Loop through the segments of the current polygon (assuming convex)
    # and test for intersection with each of the other polygon's segments
    # Returns true on first found intersection. O(n^2) ? 
    
    def intersects_with?(polygon)
      @segments.each do |current_segment|
        polygon.segments.each do |segment|
          return true if current_segment.intersects_with?(segment)
        end
      end
      false
    end
    
    # If all points in the input polygon are inside the current polygon, return true
    
    def inside?(other_polygon)
      inside_points = 0
      @points.each do |p|
        inside_points += 1 if other_polygon.has_point_inside?(p)
      end
      return inside_points == points.size
    end
    
    # If the number of times a ray intersects the line segments making up the polygon is even, 
    # then the point is outside the polygon. This algorithm has some limitations, but also works
    # for concave polygons and polygons with "holes"
    #
    # http://local.wasp.uwa.edu.au/~pbourke/geometry/insidepoly/
    
    def has_point_inside?(p)
      counter = 0
      
      @segments.each do |segment|
        p1, p2 = segment.point1, segment.point2

        if p.y > [p1.y, p2.y].min
          if p.y <= [p1.y, p2.y].max
            if p.x <= [p1.x, p2.x].max
              if p1.y != p2.y
                xinters = (p.y-p1.y) * (p2.x-p1.x)/(p2.y-p1.y) + p1.x
                if p1.x == p2.x || p.x <= xinters
                  counter += 1
                end
              end
            end
          end
        end
        
        p1 = p2
      end
      
      return (counter % 2 == 0) ? false : true
    end

  end
end