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

