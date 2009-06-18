require 'rexml/document'
require 'point'
require 'segment'
require 'vector'
require 'polygon'
 
module Geometry

  #----------------
  # polygons_from_xml
  #----------------
  
  # this really is a utility function, but without any others, 
  # lets make it a module function (accessible from Geometry.polygons_from_xml)
  
  def polygons_from_xml(xml)
    polygons = []
    
    # Use REXML because its available through the standard library
    REXML::Document.new(xml).elements.each('geometry/shape') do |shape|
      # Extract all the points of the shape
      points = []  
      shape.elements.each do |point|
        points << Point.new(point.attributes['x'], point.attributes['y'])
      end
      
      # Now create the object based on the points
      polygon = Polygon.new(points, :type => shape.attributes['id'])
      polygons << polygon
    end    
    
    return polygons
  end
  
  module_function :polygons_from_xml
  
  #----------------
  # print_statistics
  #----------------
  
  class View
    def print_statistics(polygons = [])
      # Remove polygons that are not convex
      spacer
        
      polygons.reject! do |polygon|
        if !polygon.convex?
          puts "'#{polygon.type}' is not a convex polygon"
          true
        end
      end

      # Print out the relationships of the polygons
      spacer

      polygons.each do |current_polygon|
        puts "'#{current_polygon.type}':"
        # 1) intersections
        polygons.each do |polygon|  
          next if polygon == current_polygon  
          puts "  intersects #{polygon.type}" if current_polygon.intersects_with?(polygon)
        end
        # 2) surrounds
        # 3) is seperate from
        spacer
      end
    end
    
    def spacer
      puts ''
    end
  end

end