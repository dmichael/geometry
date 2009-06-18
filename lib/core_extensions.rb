# http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/249436
# This has been really useful for looping through the points

class Array
  def each_cycle(window, start=0, stop=length)
    (start...stop+start).each do |i|
      yield((i..i+window).map {|n| self[n % length]})
    end
  end
end