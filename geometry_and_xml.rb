# Adding these might not be necessary, but lets be safe
$LOAD_PATH.unshift File.join(File.dirname(File.expand_path(__FILE__)), 'lib')
$LOAD_PATH.unshift File.join(File.dirname(File.expand_path(__FILE__)), 'test')

require 'geometry'

# Read an XML file and transform it into an array of polygons

file = ARGV.first
xml  = File.read(file || 'test/geometry.xml')

@polygons = Geometry.polygons_from_xml(xml)

# Now that we have some polygons to work with, 
# let's display them nicely.

if @polygons.size >= 2  
  Geometry::View.new.render(:polygons => @polygons)
  #Geometry::View.new.print_statistics(@polygons)
else
  puts "There are not enough polys in this file to tell you anything of import."
end