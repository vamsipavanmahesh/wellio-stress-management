# frozen_string_literal: true

require "test_helper"

class BreathingExercisesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get breathing_exercises_url
    assert_response :success
  end

  test "should get index as root" do
    get root_url
    assert_response :success
  end

  test "should get index via breathing alias" do
    get "/breathing"
    assert_response :success
  end

  test "should respond to json format" do
    get breathing_exercises_url, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal "available", json_response["status"]
    assert_equal "Breathing exercise tool is ready", json_response["message"]
  end

  test "should include security headers" do
    get breathing_exercises_url
    assert_response :success
    
    assert_equal "nosniff", response.headers["X-Content-Type-Options"]
    assert_equal "SAMEORIGIN", response.headers["X-Frame-Options"]
    assert_equal "1; mode=block", response.headers["X-XSS-Protection"]
  end

  test "should include breathing exercise content" do
    get breathing_exercises_url
    assert_response :success
    
    # Check for main container
    assert_select ".breathing-container"
    
    # Check for header
    assert_select ".breathing-header"
    assert_select "h1", "Breathing Exercise"
    
    # Check for breathing interface
    assert_select ".breathing-interface"
    assert_select ".breathing-circle"
    assert_select ".breathing-instructions"
    assert_select ".breathing-instruction"
    assert_select ".breathing-timer"
    
    # Check for controls
    assert_select ".breathing-controls"
    assert_select "button[data-action*='start']"
    assert_select "button[data-action*='stop']"
    
    # Check for info section
    assert_select ".breathing-info"
    assert_select ".benefits-list"
    
    # Check for shortcuts section
    assert_select ".breathing-shortcuts"
  end

  test "should include proper meta tags" do
    get breathing_exercises_url
    assert_response :success
    
    assert_select "title", "Stress Management - Breathing Exercise"
    assert_select "meta[name='viewport']"
  end

  test "should include breathing exercise stylesheet" do
    get breathing_exercises_url
    assert_response :success
    
    assert_select "link[href*='breathing_exercises']"
  end

  test "should handle errors gracefully" do
    # Test that the controller doesn't crash on normal requests
    get breathing_exercises_url
    assert_response :success
  end
end
