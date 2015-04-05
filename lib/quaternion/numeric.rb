
class Float # :nodoc:
  alias_method :multi_org, :*

  def * other
    if other.is_a?(Quaternion)
      other*self
    else
      self.multi_org(other)
    end
  end
end

class Fixnum # :nodoc:
  alias_method :multi_org, :*

  def * other
    if other.is_a?(Quaternion)
      other*self
    else
      self.multi_org(other)
    end
  end
end
