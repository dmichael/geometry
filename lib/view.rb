module Geometry
  class View
    attr_accessor :locals, :formatter
    
    def initialize(formatter = ConsoleFormatter.new, options = {})
      @formatter = formatter
    end
    
    def render(locals = {})
      @locals = locals
      @formatter.render(self)
    end
  end
  
  class Formatter
    def render(context)
      raise 'Abstract method called (implement me)'
    end
  end
  
  class ConsoleFormatter < Formatter
    def render(context)
      polygons = context.locals[:polygons]
      # Remove polygons that are not convex, and notify
      puts ''
      
      polygons.reject! do |polygon|
        if !polygon.convex?
          puts "'#{polygon.type}' is not a convex polygon"
          true
        end
      end

      # Print out the relationships of the polygons
      puts ''

      polygons.each do |current_polygon|
        puts "'#{current_polygon.type}'"
      
        # intersectors
        intersectors = current_polygon.find_intersectors(polygons)
        puts "  - intersects #{intersectors.map{|p| p.type}.join(', ')}" if intersectors.size > 0
      
        # surrounders
        # We neednt consider the polygons that intersect for the rest of the tests
        candidates  = polygons - intersectors
      
        surrounders = current_polygon.find_surrounders(candidates)
        puts "  - is inside #{surrounders.map{|p| p.type}.join(', ')}" if surrounders.size > 0

        # insiders        
        insiders = current_polygon.find_insiders(candidates)
        puts "  - surrounds #{insiders.map{|p| p.type}.join(', ') }" if insiders.size > 0

        # separates
        separates = current_polygon.find_separates(candidates)#(polygons - intersectors - surrounders - insiders).reject{|p| p == current_polygon}
        puts "  - is separate from #{separates.map{|p| p.type}.join(', ') }" if separates.size > 0
    
        puts ''  
      end
    end
  end
end