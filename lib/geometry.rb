require 'rexml/document'
require 'point'
require 'segment'
require 'polygon'
require 'view'
 
module Geometry
  
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
end