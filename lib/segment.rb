module Geometry
  class Segment
    attr_accessor :point1, :point2
    
    # These convenience methods help with terseness
    alias_method :p1, :point1
    alias_method :p2, :point2
    
    def initialize(point1, point2)
      @point1, @point2 = point1, point2
    end
    
    def self.new_by_arrays(point1_coordinates, point2_coordinates)
      self.new(Point.new(*point1_coordinates), Point.new(*point2_coordinates))
    end
    
    def intersects_with?(segment)
      (find_intersection_point_with(segment)) ? true : false
    end

    # Algorithm by Paul Bourke, ported to Ruby by David Michael
    # http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/
    
    # Not sure the best way to deal with the return values here.
    # I have left them in until something is figured out.
    
    def find_intersection_point_with(segment)
      denominator = ((segment.p2.y - segment.p1.y)*(p2.x - p1.x)) - 
                    ((segment.p2.x - segment.p1.x)*(p2.y - p1.y))

      numerator_a = ((segment.p2.x - segment.p1.x)*(p1.y - segment.p1.y)) - 
                    ((segment.p2.y - segment.p1.y)*(p1.x - segment.p1.x))

      numerator_b = ((p2.x - p1.x)*(p1.y - segment.p1.y)) - 
                    ((p2.y - p1.y)*(p1.x - segment.p1.x))

      if denominator == 0.0
          if numerator_a == 0.0 && numerator_b == 0.0
              # 'COINCIDENT'
              return nil
          end
          # 'PARALLEL'
          return nil
      end

      ua = numerator_a/denominator
      ub = numerator_b/denominator

      # An intersection point exists, given the following conditions
      
      if ua >= 0.0 && ua <= 1.0 && ub >= 0.0 && ub <= 1.0
        x = point1.x + ua*(p2.x - p1.x)
        y = point1.y + ua*(p2.y - p1.y)

        return Point.new(x, y)
      end
      
      # 'NOT_INTERESECTING'
      return nil
    end
  end
end