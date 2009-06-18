require 'core_extensions'

module Geometry
  class Polygon
    attr_accessor :type, :vertices, :segments

    def initialize(points = [], options = {})
      @type     = options[:type] || 'Unknown'
      @vertices = points || []
      @segments = []      
      # let create some segments for use elsewhere
      create_segments if @vertices.size >= 2
    end
    
    # Predicate method for determining if the polygon is convex
    # this could probably be used by the other methods to catch cases they would be ineffective.

    def convex?
      ['NotConvexDegenerate', 'NotConvex'].include?(convexity) ? false : true
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
    # => triangle.inside? square
    
    def inside?(polygon)
      interior_points = 0
      
      @vertices.each do |p|
        if polygon.has_interior_point?(p)
          interior_points += 1 
        end
      end
      
      # all vertices must be interior points to the target polygon
      return interior_points == @vertices.size
    end
    
    def surrounds?(polygon)
      polygon.inside?(self)
    end
    
    # If the number of times a ray intersects the line segments making up the polygon is even, 
    # then the point is outside the polygon. This algorithm has some limitations, but also works
    # for concave polygons and polygons with "holes". Does not seem to catch points on a segment.
    #
    # Algorithm by Paul Bourke, ported to Ruby by David Michael
    # http://local.wasp.uwa.edu.au/~pbourke/geometry/insidepoly/
    
    def has_interior_point?(p)
      counter = 0
      
      @segments.each do |segment|
        p1, p2 = segment.point1, segment.point2
        # Talk about conditions ... surely there is a better way
        if (p.y > [p1.y, p2.y].min) && (p.y <= [p1.y, p2.y].max) && (p.x <= [p1.x, p2.x].max) && (p1.y != p2.y)
          xinters = (p.y-p1.y) * (p2.x-p1.x)/(p2.y-p1.y) + p1.x
          
          if p1.x == p2.x || p.x <= xinters
            counter += 1
          end
        end
      end
      
      return (counter % 2 == 0) ? false : true
    end
  
    # Utility methods
    
    def find_intersectors(polygons)
      polygons.find_all do |polygon|  
        next if polygon == self
        intersects_with?(polygon)
      end
    end
    
    def find_surrounders(polygons)
      polygons.find_all do |polygon|
        next if polygon == self
        inside?(polygon)
      end
    end
    
    def find_insiders(polygons)
      polygons.find_all do |polygon|
        next if polygon == self
        surrounds?(polygon)
      end
    end
    
    def find_separates(polygons)
      polygons.find_all do |polygon|
        next if polygon == self
        !inside?(polygon) && !surrounds?(polygon) && !intersects_with?(polygon)
      end
    end
    
    # Algorithm ported from 
    # "Testing the Convexity of a Polygon" by Peter Schorn and Frederick Fisher
    # in "Graphics Gems IV", Academic Press, 1994
    #
    # This port has NOT been thoroughly tested, but catches all example cases
    # This should be reexamined... decidedly inelegant
    
    def convexity
      angle_sign        = 0
      direction_changes = 0
      current_direction = direction(@vertices[0], @vertices[1]) 

      @vertices.each_cycle(2) do |points|
        p1, p2, p3 = points[0], points[1], points[2]

        this_direction = direction(p2, p3)
        if this_direction == -current_direction 
      	    direction_changes += 1
    	  end
      	current_direction = this_direction

    	  this_sign = which_side(p1, p2, p3)
        if angle_sign == -this_sign
          return 'NotConvex'
        end
        angle_sign = this_sign
      end
      # vertices.each_cycle
      
      if direction_changes > 2
        return (angle_sign) ? 'NotConvex' : 'NotConvexDegenerate'
      end

      if angle_sign  > 0
        return 'ConvexCCW' 
      elsif angle_sign  < 0
        return 'ConvexCW'
      else
        return 'ConvexDegenerate'
      end
    end

  private 

    # this could be moved to the Segment (vector?)

    def direction(p1, p2)		
      if (p1.x < p2.x) then return -1 end	# p1 is less than p2.
      if (p1.x > p2.x) then return  1	end # p1 is greater than p2.
      if (p1.y < p2.y) then return -1	end # p1 is less than p2.
      if (p1.y > p2.y) then return  1	end # p1 is greater than p2.
      return 0 # p1 is equal to p2.
    end

    def which_side(p1, p2, p3)
      result = (p1.x - p2.x) * (p2.y - p3.y) - (p1.y - p2.y) * (p2.x - p3.x)
      if (result < 0) then return -1	end # p2 lies to the left  (p2p3 turns CW).
      if (result > 0) then return  1	end # p2 lies to the right (p2p3 turns CCW).
      return 0 # p2 lies on the line from p1 to p3.
    end 

    # This method is only used by the initializer
    def create_segments
      @vertices.each_cycle(1) { |points| @segments << Segment.new(*points) }
    end
  
  end
end