$LOAD_PATH.unshift File.join(File.dirname(File.expand_path(__FILE__)), 'lib')
$LOAD_PATH.unshift File.join(File.dirname(File.expand_path(__FILE__)), 'test')

require 'geometry'

polygons = Geometry.polygons_from_xml(File.read('test/geometry.xml'))

puts '' # spacer

polygons.reject!{|polygon|
  if !polygon.convex?
    puts "'#{polygon.type}' is not a convex polygon"
    true
  end
}

puts '' # spacer

polygons.each do |current_polygon|
  puts "'#{current_polygon.type}':"
  # 1) intersections
  polygons.each do |polygon|  
    next if polygon == current_polygon  
    puts "  intersects #{polygon.type}" if current_polygon.intersects?(polygon)
  end
  # 2) surrounds
  # 3) is seperate from
  puts ''
end