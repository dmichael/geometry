require 'core_extensions'
require 'polygon_classifier'

module Geometry
  class Polygon
    attr_accessor :type, :points, :angles, :segments

    def initialize(points = [], options = {})
      @type   = options[:type] || 'Unknown'
      @points = points || []
      @angles = []
      @segments = []
      calculate_angles if @points.size >= 3
      create_segments if @points.size >= 2
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
      counter = 0
      points.each do |p|
        counter += 1 if other_polygon.has_point_inside?(p)
      end
      return counter == points.size
    end
    
    # If the number of times a ray intersects the line segments making up the polygon is even, 
    # then the point is outside the polygon.
    #
    # http://local.wasp.uwa.edu.au/~pbourke/geometry/insidepoly/
    
    def has_point_inside?(p)
      counter = 0
      n  = points.size
      p1 = points[0]
      
      @segments.each do |segment|
        p1, p2 = segment.point1, segment.point2
        
        if p.y > min(p1.y, p2.y)
          if p.y <= max(p1.y, p2.y)
            if p.x <= max(p1.x, p2.x)
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

      # for i in 1..n do
      #   p2 = points[i % n]
      #   if (p.y > min(p1.y,p2.y))
      #     if (p.y <= max(p1.y,p2.y))
      #       if (p.x <= max(p1.x,p2.x))
      #         if (p1.y != p2.y)
      #           xinters = (p.y-p1.y) * (p2.x-p1.x)/(p2.y-p1.y) + p1.x
      #           if (p1.x == p2.x || p.x <= xinters)
      #             counter += 1
      #           end
      #         end
      #       end
      #     end
      #   end
      #   p1 = p2
      # end
    end
    
    def min(x,y) 
      (x < y ? x : y)
    end
    
    def max(x,y) 
      (x > y ? x : y)
    end

    def create_segments
      @points.each_cycle(1) do |points|
        @segments << Segment.new(*points)
      end
    end
    
    #-------------------------------------------------
    # These are not used, but were part of the process
    #-------------------------------------------------
    
    def calculate_angles
      @points.each_cycle(2, 0) do |points|
        @angles << calculate_angle_from_points(points)
      end
    end
    
    def calculate_angle_from_points(points)
      raise "I can only give you an angle from 1 or 2 vectors (2-3 points)" if points.size > 3

      x1, y1 = points[0].x, points[0].y    
      x2, y2 = points[1].x, points[1].y
      x3, y3 = points[2].x, points[2].y

      slope1 = (y2 - y1)/(x2 - x1)
      slope2 = (y3 - y2)/(x3 - x2)

      if slope1.infinite?
        angle = Math.atan(1/slope2).degrees
      elsif slope2.infinite? 
        angle = Math.atan(1/slope1).degrees
      else
        angle = Math.atan((slope1-slope2)/1+(slope1*slope2)).degrees #* 180/(Math::PI);    
      end

      return angle
    end
  
  end
end