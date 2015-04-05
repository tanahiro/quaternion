root_dir = "#{__dir__}/.."

require 'matrix'
require "#{root_dir}/lib/quaternion/version"
require "#{root_dir}/lib/quaternion/numeric"

##
# Class for Quaternion calculation.
class Quaternion
  include Math

  ##
  # Returns an instance of Quaternion.
  # The following code instanciate a quaternion of
  # q0 + q1 _i_ + q2 _j_ + q3 _k_, where q0 = 1, q1 = 2, q2 = 3 and q3 = 4.
  #   q = Quaternion.new(1.0, 2.0, 3.0, 4.0)         # => Quaternion(1.0; Vector[2.0, 3.0, 4.0])
  #   q = Quaternion.new(1.0, [2.0, 3.0, 4.0])       # => Quaternion(1.0; Vector[2.0, 3.0, 4.0])
  #   q = Quaternion.new(1.0, Vector[2.0, 3.0, 4.0]) # => Quaternion(1.0; Vector[2.0, 3.0, 4.0])
  def initialize *vars
    case vars.size
    when 2
      @w = vars[0]

      case vars[1]
      when Vector
        @v = vars[1].clone
      when Array
        @v = Vector.elements(vars[1], true)
      else
        raise ArgumentError, "Invalid type"
      end
    when 4
      @w = vars[0]
      @v = Vector.elements(vars[1..3], true)
    end
  end

  ##
  # Returns element +i+.
  #   q = Quaternion.new(1.0, 2.0, 3.0, 4.0)
  #   q[0]  # => 1.0
  #   q[:w] # => 1.0
  #   q[:x] # => 2.0
  #   q[:y] # => 3.0
  #   q[:z] # => 4.0
  #   q[:v] # => Vector[2.0, 3.0, 4.0]
  def [] i
    case i
    when :w, 0
      return @w
    when :x, 1
      return @v[0]
    when :y, 2
      return @v[1]
    when :z, 3
      return @v[2]
    when :v
      return @v
    else
      raise ArgumentError, "Invalid index"
    end
  end

  ##
  # Sets +var+ to element +i+
  #   q = Quaternion.new(1.0, 2.0, 3.0, 4.0)
  #   q[0] = 0.0
  #   q # => Quaternion(0.0; Vector[2.0, 3.0, 4.0])
  def []= i, var
    case i
    when :w, 0
      @w = var
    when :x, 1
      @v = Vector.elements([var, @v[1], @v[2]])
    when :y, 2
      @v = Vector.elements([@v[0], var, @v[2]])
    when :z, 3
      @v = Vector.elements([@v[0], @v[1], var])
    when :v
      if var.is_a?(Array)
        @v = Vector.elements(var, true)
      elsif var.is_a?(Vector)
        @v = var
      else
        raise ArgumentError, "Invalid type. Should be Array or Vector"
      end
    else
      raise ArgumentError, "Invalid index"
    end
  end

  ##
  # Compares with other Quaternion
  def == other
    if other.is_a?(self.class)
      if (@w == other[:w]) and (@v == other[:v])
        return true
      else
        return false
      end
    else
      return false
    end
  end

  ##
  # Returns product with +other+.
  # +other+ can be Quaternion or Numeric.
  #   q = Quaternion.new(1.0, 2.0, 3.0, 4.0)
  #   q*2 # => Quarternion(2.0; Vector[4.0, 6.0, 8.0])
  #
  #   q1 = Quaternion.new(1.0, 4.0, 5.0, 6.0)
  #   q*q1 # => Quaternion(-46.0, Vector[4.0, 12.0, 8.0])
  def * other
    case other
    when self.class
      w = @w*other[:w] - @v.inner_product(other[:v])
      v = @w*other[:v] + @v*other[:w] + @v.cross_product(other[:v])

      return self.class.new(w, v)
    when Numeric
      w = @w*other
      v = @v*other

      return self.class.new(w, v)
    else
      raise ArgumentError, "Invalide type"
    end
  end

  ##
  # Devision by a scalar +other+.
  # Returns Quaternion with each element is divided by +other+.
  #   q = Quaternion.new(1.0, 2.0, 3.0, 4.0)
  #   q/2 # => Quaternion(0.5; Vector[1.0, 1.5, 2.0])
  def / other
    case other
    when Numeric
      w = @w/other
      v = @v/other

      return self.class.new(w, v)
    else
      raise ArgumentError, "Invalid type"
    end
  end

  ##
  # Returns conjugate of +self+
  #   q = Quaternion.new(1.0, 2.0, 3.0, 4.0)
  #   q.conjugate # => Quaternion(1.0; Vector[-2.0, -3.0, -4.0])
  def conjugate
    return self.class.new(@w, -@v)
  end

  ##
  # Returns norm of +self+
  #   q = Quaternion.new(1.0, 2.0, 3.0, 4.0)
  #   q.norm # => 5.477225575051661
  def norm
    return sqrt(@w**2 + @v.inner_product(@v))
  end
  alias magnitude norm

  ##
  # Returns inverse of +self+.
  #   q = Quaternion.new(1.0, 2.0, 3.0, 4.0)
  #   q.inverse # => Quaternion(0.03333333333333333; Vector[-0.06666666666666667, -0.1, -0.13333333333333333])
  def inverse
    return (self.conjugate)/(self.norm**2)
  end

  ##
  # Returns normailzed Quaternion
  #   q = Quaternion.new(1.0, 2.0, 3.0, 4.0)
  #   q.normalize # => Quaternion(0.18257418583505536; Vector[0.3651483716701107, 0.5477225575051661, 0.7302967433402214])
  def normalize
    return self/self.magnitude
  end

  ##
  # Destructive method of Quaternion#normalize
  def normalize!
    m = self.magnitude

    @w /= m
    @v /= m

    return self
  end

  ##
  # Returns string expression of self
  #   q = Quaternion.new(1.0, 2.0, 3.0, 4.0)
  #   q.inspect # => "Quaternion(1.0; Vector[2.0, 3.0, 4.0])"
  def inspect
    return "Quaternion(#{@w}; #{@v})"
  end
  alias to_s inspect
end

