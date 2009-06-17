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
    
    def intersects?(polygon)
      @segments.each do |segment|
        polygon.segments.each do |segment2|
          return true if segment2.intersects_with?(segment)
        end
      end
      false
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