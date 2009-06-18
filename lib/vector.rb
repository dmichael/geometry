# Used for the cross-product
# http://github.com/DanielVartanov/ruby-geometry/blob/311031cb4a260b3f5303bac8d1b312f6c108d3b8/lib/vector.rb

# This class could be collapsed into the Point
# but they are conceptually different
module Geometry
  class Vector
    attr_accessor :x, :y
    
    def initialize(x, y)
      @x, @y = x, y
    end
    
    def cross_product(vector)
      @x * vector.y - @y * vector.x
    end
  end
end