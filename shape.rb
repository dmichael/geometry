require 'core_extensions'
require 'polygon_classify'

class Shape
  attr_accessor :type, :points, :angles
  
  def initialize(type)
    @type   = type
    @points = []
  end
  
  def convex?
    polygon_classify = PolygonClassify.new
    polygon_classify.classify(@points)
    #calculate_angles
    
    # @angles.each do |angle|
    #       puts angle
    #     end
  end
  
  def calculate_angles
    @angles = Array.new(@points.size)

    @points.each_cycle_with_index(2, 0) do |cycle, i|
      calculate_angle_from_points(cycle)
    end
  end


  def sign(x)
    return (x < 0) ? -1 : 1
  end

  def calculate_angle_from_points(points)
    raise "I can only give you an angle from 1 or 2 vectors (2-3 points)" if points.size > 3
    
    x1, y1 = points[0].x, points[0].y    
    x2, y2 = points[1].x, points[1].y
    x3, y3 = points[2].x, points[2].y
      
    slope1 = (y2 - y1)/(x2 - x1)
    slope2 = (y3 - y2)/(x3 - x2)
    
    #puts ">>>> #{slope1} #{slope2}"

    if slope1.infinite?
      angle = Math.atan(1/slope2).degrees
    elsif slope2.infinite? 
      angle = Math.atan(1/slope1).degrees
    else
      angle = Math.atan((slope1-slope2)/1+(slope1*slope2)).degrees #* 180/(Math::PI);    
    end
    
    i = @points.index(points[0])
    @angles[i] = angle
  end

end