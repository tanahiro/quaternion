require "#{__dir__}/minitest_helper"

class TestQuaternion < Minitest::Test
  def setup
    @q = Quaternion.new(1.0, 2.0, 3.0, 4.0)
  end

  def test_that_it_has_a_version_number
    refute_nil ::Quaternion::VERSION
  end

  def test_getter
    assert_equal(1.0, @q[0])
    assert_equal(1.0, @q[:w])

    assert_equal(2.0, @q[1])
    assert_equal(2.0, @q[:x])

    assert_equal(3.0, @q[2])
    assert_equal(3.0, @q[:y])

    assert_equal(4.0, @q[3])
    assert_equal(4.0, @q[:z])

    assert_equal(Vector[2.0, 3.0, 4.0], @q[:v])

    assert_raises(ArgumentError) {
      @q[4]
    }
  end

  def test_setter
    @q[0] = -1.0
    expected = Quaternion.new(-1.0, 2.0, 3.0, 4.0)
    assert_equal(expected, @q)
    
    @q[1] = -2.0
    expected = Quaternion.new(-1.0, -2.0, 3.0, 4.0)
    assert_equal(expected, @q)
    
    @q[2] = -3.0
    expected = Quaternion.new(-1.0, -2.0, -3.0, 4.0)
    assert_equal(expected, @q)
    
    @q[3] = -4.0
    expected = Quaternion.new(-1.0, -2.0, -3.0, -4.0)
    assert_equal(expected, @q)

    @q[:v] = Vector[5.0, 6.0, 7.0]
    expected = Quaternion.new(-1.0, 5.0, 6.0, 7.0)
    assert_equal(expected, @q)
  end

  def test_compare
    assert(@q == Quaternion.new(1.0, 2.0, 3.0, 4.0))
  end

  def test_multiplier
    expected = Quaternion.new(2.0, 4.0, 6.0, 8.0)
    assert_equal(expected, @q*2)
    assert_equal(expected, 2*@q)
    assert_equal(expected, 2.0*@q)

    q        = Quaternion.new(1.0, 4.0, 5.0, 6.0)
    expected = Quaternion.new(-46.0, 4.0, 12.0, 8.0)
    assert_equal(expected, @q*q)
  end

  def test_divide
    expected = Quaternion.new(0.5, 1.0, 1.5, 2.0)
    assert_equal(expected, @q/2.0)
  end

  def test_conjugate
    expected = Quaternion.new(1.0, -2.0, -3.0, -4.0)
    assert_equal(expected, @q.conjugate)
  end

  def test_norm
    expected = Math.sqrt(30.0)

    assert_in_delta(expected, @q.norm)
  end

  def test_inverse
    expected = Quaternion.new(1.0/30.0, -2.0/30.0, -3.0/30.0, -4.0/30.0)

    assert_equal(expected, @q.inverse)

    assert_equal(Quaternion.new(1.0, 0.0, 0.0, 0.0), @q*(@q.inverse))
  end

  def test_normalize
    m = Math.sqrt(30.0)
    expected = Quaternion.new(1.0/m, 2.0/m, 3.0/m, 4.0/m)

    assert_equal(expected, @q.normalize)
  end

  def test_normalize!
    m = Math.sqrt(30.0)
    expected = Quaternion.new(1.0/m, 2.0/m, 3.0/m, 4.0/m)
    @q.normalize!

    assert_equal(expected, @q)
  end
end

