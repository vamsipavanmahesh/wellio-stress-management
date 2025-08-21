# frozen_string_literal: true

# Service class for breathing exercise business logic
# Encapsulates breathing pattern calculations and validation
class BreathingExerciseService
  # Default breathing pattern configuration
  DEFAULT_CONFIG = {
    inhale_duration: 3,
    exhale_duration: 3,
    min_duration: 2,
    max_duration: 8
  }.freeze

  # Breathing pattern types for future extensibility
  PATTERN_TYPES = {
    box: { inhale: 4, hold: 4, exhale: 4, hold_after: 4 },
    four_seven_eight: { inhale: 4, hold: 7, exhale: 8 },
    equal: { inhale: 3, exhale: 3 },
    relaxing: { inhale: 4, exhale: 6 }
  }.freeze

  attr_reader :inhale_duration, :exhale_duration

  def initialize(inhale_duration: DEFAULT_CONFIG[:inhale_duration], 
                 exhale_duration: DEFAULT_CONFIG[:exhale_duration])
    @inhale_duration = validate_duration(inhale_duration)
    @exhale_duration = validate_duration(exhale_duration)
  end

  # Calculate total cycle duration in milliseconds
  def cycle_duration_ms
    (inhale_duration + exhale_duration) * 1000
  end

  # Get breathing pattern as a hash for frontend consumption
  def pattern_config
    {
      inhale_duration: inhale_duration,
      exhale_duration: exhale_duration,
      cycle_duration_ms: cycle_duration_ms,
      inhale_ratio: inhale_ratio,
      recommended_sessions: recommended_sessions
    }
  end

  # Calculate the ratio of inhale time to total cycle time
  def inhale_ratio
    inhale_duration.to_f / (inhale_duration + exhale_duration)
  end

  # Get recommended number of sessions based on pattern
  def recommended_sessions
    case cycle_duration_ms
    when 0..4000 then 10  # Fast breathing: more sessions
    when 4001..8000 then 8 # Medium breathing: moderate sessions
    else 6 # Slow breathing: fewer sessions
    end
  end

  # Validate if the breathing pattern is healthy
  def healthy_pattern?
    # Basic validation: exhale should not be significantly shorter than inhale
    # This prevents hyperventilation patterns
    exhale_duration >= (inhale_duration * 0.8)
  end

  # Get breathing pattern type based on current configuration
  def pattern_type
    case [inhale_duration, exhale_duration]
    when [4, 4] then :box
    when [4, 6] then :relaxing
    when [3, 3] then :equal
    else :custom
    end
  end

  # Create a service instance from a pattern type
  def self.from_pattern(pattern_type)
    pattern = PATTERN_TYPES[pattern_type.to_sym]
    return new unless pattern

    new(
      inhale_duration: pattern[:inhale],
      exhale_duration: pattern[:exhale]
    )
  end

  private

  def validate_duration(duration)
    duration = duration.to_i
    min = DEFAULT_CONFIG[:min_duration]
    max = DEFAULT_CONFIG[:max_duration]
    
    if duration < min || duration > max
      raise ArgumentError, "Duration must be between #{min} and #{max} seconds"
    end
    
    duration
  end
end 