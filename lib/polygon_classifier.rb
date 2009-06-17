module Geometry
  class PolygonClassifier
    #attr_accessor :current_direction, :this_direction, :angle_sign, :direction_changes
    def initialize(points)
      @points = points
    end

    def self.overlap?(shape1, shape2) 

      shape1.points.each_cycle(2) do |shape1_points|
        x1, y1 = shape1_points[0].x, shape1_points[0].y
        x2, y2 = shape1_points[1].x, shape1_points[1].y
      

        puts "#{shape1.type} -> #{shape1_points[0].inspect} #{shape1_points[1].inspect}"

        shape2.points.each_cycle(2) do |shape2_points|
        
          #puts shape2_points[0].inspect
          #puts shape2_points[1].inspect
          puts "#{shape2.type} -> #{shape2_points[0].inspect} #{shape2_points[1].inspect}"
        
          u1, v1 = shape2_points[0].x, shape2_points[0].y
          u2, v2 = shape2_points[1].x, shape2_points[1].y
        
          b1 = (y2-y1)/(x2-x1) #(A) 
          b2 = (v2-v1)/(u2-u1) #(B)

          a1 = y1-b1*x1 
          a2 = v1-b2*u1

          xi = -((a1-a2)/(b1-b2)) #(C) 
          yi = a1+b1*xi 

          if (x1-xi)*(xi-x2) >= 0 && (u1-xi)*(xi-u2)>=0 && (y1-yi)*(yi-y2)>=0 && (v1-yi)*(yi-v2)>=0 
            puts "lines cross at #{xi}, #{yi}"
          else 
            puts "lines do not cross" 
          end
        end
              puts             
      end
    end

    def convexity
      @angle_sign = 0
      @direction_changes = 0
    
      # If any of the points are the same, it is degenerate!
      # This is currently not checked for...
    
      first  = @points[0]
    	second = @points[1]
	
      @current_direction = compare(first, second);
      # while( GetDifferentPoint(f, second, &third) ) {
      #   check_triple;
      # }
      # 
      @points.each_cycle(2) do |cycle|
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
      if (p.x > q.x) then return  1	end # p is greater than q.
      if (p.y < q.y) then return -1	end # p is less than q.
      if (p.y > q.y) then return  1	end # p is greater than q.
      return 0 # p is equal to q.
    end

    def which_side(p, q, r)
      result = (p.x - q.x) * (q.y - r.y) - (p.y - q.y) * (q.x - r.x)
      if (result < 0) then return -1	end # q lies to the left  (qr turns CW).
      if (result > 0) then return  1	end # q lies to the right (qr turns CCW).
      return 0 # q lies on the line from p to r.
    end

  end
end