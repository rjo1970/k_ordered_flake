require 'test_helper'

class KOrderedFlakeTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::KOrderedFlake::VERSION
  end

  def test_it_can_convert_big_integers_to_base_62
    assert KOrderedFlake.to_base_62(0) == "0"
    assert KOrderedFlake.to_base_62(61) == "z"
    assert KOrderedFlake.to_base_62(62) == "10"
  end

  def test_it_has_an_atom
    assert KOrderedFlake::STATE.class == Concurrent::Atom
    assert KOrderedFlake::STATE.value.keys == [:time, :identity, :counter]
    assert KOrderedFlake::STATE.value[:time] > 0
    assert KOrderedFlake::STATE.value[:identity] > 0
    assert KOrderedFlake::STATE.value[:counter] >= 0
  end

  def test_it_can_clock_the_atom_at_same_time
    initial = KOrderedFlake::STATE.value
    result = KOrderedFlake::clock(initial, initial[:time])
    assert result[:counter] > 0
  end

  def test_it_can_clock_the_counter_65535_times_before_it_breaks
    initial = KOrderedFlake::STATE.value
    warmed = KOrderedFlake::clock(initial, initial[:time] + 1)
    65535.times do |n|
      warmed = KOrderedFlake::clock(warmed, warmed[:time])
      assert (n + 1) == warmed[:counter]
    end
    begin
      KOrderedFlake::clock(warmed, warmed[:time])
      fail "Expected exception"
    rescue  KOrderedFlake::CounterOverflowException
    end
  end

  def test_it_can_clock_the_atom_at_an_incremented_time
    initial = KOrderedFlake::STATE.value
    result = KOrderedFlake::clock(initial, initial[:time] + 1 )
    assert result[:counter] == 0
    assert result[:time] == initial[:time] + 1
  end

  def test_flakes_are_sequentially_ordered
    original = (0..500).to_a.collect {|x| KOrderedFlake::flake }
    sorted = original.shuffle.sort
    assert original == sorted
  end

  def test_reversing_time_yields_an_exception
    initial = KOrderedFlake::STATE.value
    past_time = initial[:time] - 1
    begin
      KOrderedFlake::clock(initial, past_time)
      fail("Should have thrown an exception for time being in the past")
    rescue KOrderedFlake::TimeDiscontinuityException
    end
  end

end
