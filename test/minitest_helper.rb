$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'quaternion'

require 'minitest/autorun'

module MinitestHelper
  def quaternion_assert_in_delta expected, actual, delta = 0.001, message = nil
    assert_in_delta(expected[:w], actual[:w], delta, message)
    assert_in_delta(expected[:x], actual[:x], delta, message)
    assert_in_delta(expected[:y], actual[:y], delta, message)
    assert_in_delta(expected[:z], actual[:z], delta, message)
  end
end
