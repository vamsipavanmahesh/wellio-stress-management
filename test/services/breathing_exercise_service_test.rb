# frozen_string_literal: true

require "test_helper"

class BreathingExerciseServiceTest < ActiveSupport::TestCase
  def setup
    @service = BreathingExerciseService.new
  end

  test "should initialize with default values" do
    assert_equal 3, @service.inhale_duration
    assert_equal 3, @service.exhale_duration
  end

  test "should initialize with custom values" do
    service = BreathingExerciseService.new(inhale_duration: 4, exhale_duration: 6)
    assert_equal 4, service.inhale_duration
    assert_equal 6, service.exhale_duration
  end

  test "should calculate cycle duration correctly" do
    assert_equal 6000, @service.cycle_duration_ms
  end

  test "should calculate inhale ratio correctly" do
    assert_equal 0.5, @service.inhale_ratio
  end

  test "should generate pattern config" do
    config = @service.pattern_config
    
    assert_equal 3, config[:inhale_duration]
    assert_equal 3, config[:exhale_duration]
    assert_equal 6000, config[:cycle_duration_ms]
    assert_equal 0.5, config[:inhale_ratio]
    assert config[:recommended_sessions].is_a?(Integer)
  end

  test "should recommend appropriate session count" do
    fast_service = BreathingExerciseService.new(inhale_duration: 2, exhale_duration: 2)
    slow_service = BreathingExerciseService.new(inhale_duration: 6, exhale_duration: 6)
    
    assert_equal 10, fast_service.recommended_sessions
    assert_equal 6, slow_service.recommended_sessions
  end

  test "should validate healthy patterns" do
    healthy_service = BreathingExerciseService.new(inhale_duration: 3, exhale_duration: 4)
    unhealthy_service = BreathingExerciseService.new(inhale_duration: 6, exhale_duration: 2)
    
    assert healthy_service.healthy_pattern?
    refute unhealthy_service.healthy_pattern?
  end

  test "should identify pattern types" do
    box_service = BreathingExerciseService.new(inhale_duration: 4, exhale_duration: 4)
    relaxing_service = BreathingExerciseService.new(inhale_duration: 4, exhale_duration: 6)
    equal_service = BreathingExerciseService.new(inhale_duration: 3, exhale_duration: 3)
    custom_service = BreathingExerciseService.new(inhale_duration: 5, exhale_duration: 7)
    
    assert_equal :box, box_service.pattern_type
    assert_equal :relaxing, relaxing_service.pattern_type
    assert_equal :equal, equal_service.pattern_type
    assert_equal :custom, custom_service.pattern_type
  end

  test "should create service from pattern type" do
    box_service = BreathingExerciseService.from_pattern(:box)
    assert_equal 4, box_service.inhale_duration
    assert_equal 4, box_service.exhale_duration
    
    relaxing_service = BreathingExerciseService.from_pattern(:relaxing)
    assert_equal 4, relaxing_service.inhale_duration
    assert_equal 6, relaxing_service.exhale_duration
  end

  test "should return default service for invalid pattern" do
    service = BreathingExerciseService.from_pattern(:invalid)
    assert_equal 3, service.inhale_duration
    assert_equal 3, service.exhale_duration
  end

  test "should validate duration constraints" do
    assert_raises(ArgumentError) do
      BreathingExerciseService.new(inhale_duration: 1)
    end
    
    assert_raises(ArgumentError) do
      BreathingExerciseService.new(exhale_duration: 10)
    end
  end

  test "should handle string inputs" do
    service = BreathingExerciseService.new(inhale_duration: "4", exhale_duration: "5")
    assert_equal 4, service.inhale_duration
    assert_equal 5, service.exhale_duration
  end

  test "should have accessible pattern types" do
    assert BreathingExerciseService::PATTERN_TYPES.key?(:box)
    assert BreathingExerciseService::PATTERN_TYPES.key?(:four_seven_eight)
    assert BreathingExerciseService::PATTERN_TYPES.key?(:equal)
    assert BreathingExerciseService::PATTERN_TYPES.key?(:relaxing)
  end

  test "should have proper default configuration" do
    config = BreathingExerciseService::DEFAULT_CONFIG
    
    assert_equal 3, config[:inhale_duration]
    assert_equal 3, config[:exhale_duration]
    assert_equal 2, config[:min_duration]
    assert_equal 8, config[:max_duration]
  end
end 