class Point
  attr_accessor :x, :y
  
  def initialize(x, y)
    @x, @y = x.to_f, y.to_f
  end
end