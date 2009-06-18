# http://github.com/DanielVartanov/ruby-geometry/blob/311031cb4a260b3f5303bac8d1b312f6c108d3b8/lib/segment.rb

module Geometry  
  class Segment
    attr_accessor :point1, :point2
    
    def initialize(point1, point2)
      @point1, @point2 = point1, point2
    end
    
    def self.new_by_arrays(point1_coordinates, point2_coordinates)
      self.new(Point.new(*point1_coordinates), Point.new(*point2_coordinates))
    end
 
    def leftmost_endpoint
      ((point1.x <=> point2.x) == -1) ? point1 : point2
    end
 
    def rightmost_endpoint
      ((point1.x <=> point2.x) == 1) ? point1 : point2
    end
 
    def topmost_endpoint
      ((point1.y <=> point2.y) == 1) ? point1 : point2
    end
 
    def bottommost_endpoint
      ((point1.y <=> point2.y) == -1) ? point1 : point2
    end
 
    def lies_on_one_line_with?(segment)
      Segment.new(point1, segment.point1).parallel_to?(self) &&
        Segment.new(point1, segment.point2).parallel_to?(self)
    end
 
    def intersects_with?(segment)
      Segment.have_intersecting_bounds?(self, segment) &&
        lies_on_line_intersecting?(segment) &&
        segment.lies_on_line_intersecting?(self)
    end
    
    def to_vector
      Vector.new(point2.x - point1.x, point2.y - point1.y)
    end
 
  protected
 
    def self.have_intersecting_bounds?(segment1, segment2)
      intersects_on_x_axis =
        (segment1.leftmost_endpoint.x < segment2.rightmost_endpoint.x ||
        segment1.leftmost_endpoint.x == segment2.rightmost_endpoint.x) &&
        (segment2.leftmost_endpoint.x < segment1.rightmost_endpoint.x ||
        segment2.leftmost_endpoint.x == segment1.rightmost_endpoint.x)
    
      intersects_on_y_axis =
        (segment1.bottommost_endpoint.y < segment2.topmost_endpoint.y ||
        segment1.bottommost_endpoint.y == segment2.topmost_endpoint.y) &&
        (segment2.bottommost_endpoint.y < segment1.topmost_endpoint.y ||
        segment2.bottommost_endpoint.y == segment1.topmost_endpoint.y)
 
      intersects_on_x_axis && intersects_on_y_axis
    end
 
    def lies_on_line_intersecting?(segment)
      vector_to_first_endpoint = Segment.new(self.point1, segment.point1).to_vector
      vector_to_second_endpoint = Segment.new(self.point1, segment.point2).to_vector
 
      #FIXME: '>=' and '<=' method of Fixnum and Float should be overriden too (take precision into account)
      # there is a rare case, when this method is wrong due to precision
      self.to_vector.cross_product(vector_to_first_endpoint) *
        self.to_vector.cross_product(vector_to_second_endpoint) <= 0
    end
  end
end