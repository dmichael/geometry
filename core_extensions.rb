# http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/249436
class Array
  def each_cycle_with_index(window, start=0, stop=length)
    (start...stop+start).each do |i|
      yield((i..i+window).map {|n| self[n % length]}, i)
    end
  end
end

class Numeric
  def degrees
    self * 180/(Math::PI)
    # * Math::PI / 180
  end
end