# frozen_string_literal: true

# Controller for breathing exercise functionality
# Provides public access to stress management tools without authentication
class BreathingExercisesController < ApplicationController
  # Skip CSRF protection for this public wellness tool
  # This is acceptable since we're not handling any sensitive data or mutations
  skip_before_action :verify_authenticity_token, only: [:index]
  
  # Set security headers for public wellness content
  before_action :set_wellness_headers
  
  # GET /breathing_exercises
  # GET /breathing
  # GET /
  def index
    # Simple public access - no authentication required
    # Future considerations:
    # - Add optional session tracking for analytics
    # - Implement rate limiting for abuse prevention
    # - Add A/B testing capabilities for different breathing patterns
    
    respond_to do |format|
      format.html
      format.json { render json: { status: 'available', message: 'Breathing exercise tool is ready' } }
    end
  rescue StandardError => e
    Rails.logger.error "Breathing exercise error: #{e.message}"
    respond_to do |format|
      format.html { render 'error', status: :internal_server_error }
      format.json { render json: { error: 'Service temporarily unavailable' }, status: :service_unavailable }
    end
  end

  private

  def set_wellness_headers
    # Set appropriate headers for wellness content
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'SAMEORIGIN'
    response.headers['X-XSS-Protection'] = '1; mode=block'
  end
end
