class PolygonClassify
  attr_accessor :current_direction, :this_direction, :angle_sign, :direction_changes

  def classify(points)
    @angle_sign = 0
    @direction_changes = 0
    
    # If any of the points are the same, it is degenerate!
    # This is currently not checked for...
    
    first  = points[0]
  	second = points[1]
	
    @current_direction = compare(first, second);
    # while( GetDifferentPoint(f, second, &third) ) {
    #   check_triple;
    # }
    # 
    points.each_cycle_with_index(2) do |cycle, i|
      puts cycle.inspect
      check_triple(*cycle)
    end
    
    #/* Must check that end of list continues back to start properly */
    # if compare(second, saveFirst)
    #       third = saveFirst; 
    #       check_triple;
    # end
    # third = saveSecond;  
    # check_triple;

    if @direction_changes > 2
      return (@angle_sign) ? 'NotConvex' : 'NotConvexDegenerate'
    end
    if @angle_sign  > 0
      return 'ConvexCCW';
    end
    if @angle_sign  < 0
      return 'ConvexCW';
    end
    
    return 'ConvexDegenerate';
  
  end
  
  def check_triple(first, second, third)
    @this_direction = compare(second, third)
    if @this_direction == -@current_direction 
  	    @direction_changes += 1;
	  end
	  
  	@current_direction = @this_direction
  	
	  @this_sign = which_side(first, second, third)
  	if @this_sign
      if @angle_sign == -@this_sign
        return 'NotConvex'
      end
      @angle_sign = @this_sign;
  	end
	
  end
  
  def compare(p, q)		
      if (p.x < q.x) then return -1 end	# p is less than q.
      if (p.x > q.x) then return  1	end# p is greater than q.
      if (p.y < q.y) then return -1	end# p is less than q.
      if (p.y > q.y) then return  1	end# p is greater than q.
      return 0			# p is equal to q.
  end

  def which_side(p, q, r)
    result = (p.x - q.x) * (q.y - r.y) - (p.y - q.y) * (q.x - r.x)
    if (result < 0) then return -1	end#/* q lies to the left  (qr turns CW).	*/
    if (result > 0) then return  1	end#/* q lies to the right (qr turns CCW).	*/
    return 0			#/* q lies on the line from p to r.	*/
  end


end