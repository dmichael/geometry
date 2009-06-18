module Geometry
  class View
    #----------------
    # print_statistics
    #----------------
  
    def print_statistics(polygons = [])
      # Remove polygons that are not convex, and notify
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
    
        spacer  
      end
    end

    def spacer
      puts ''
    end
  end
end