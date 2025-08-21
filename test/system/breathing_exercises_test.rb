# frozen_string_literal: true

require "application_system_test_case"

class BreathingExercisesTest < ApplicationSystemTestCase
  test "visiting the breathing exercise page" do
    visit breathing_exercises_url
    
    assert_selector "h1", text: "Breathing Exercise"
    assert_selector ".breathing-circle"
    assert_selector ".breathing-controls"
    assert_selector ".breathing-settings"
  end

  test "can start and stop breathing exercise" do
    visit breathing_exercises_url
    
    # Check initial state
    assert_selector ".breathing-instruction", text: "Ready to breathe"
    assert_selector ".breathing-timer", text: "00:00"
    
    # Start the exercise
    click_on "Start"
    
    # Wait for animation to start
    sleep(0.5)
    
    # Check that instruction changed
    assert_selector ".breathing-instruction", text: /Breathe (in|out)\.\.\./
    
    # Stop the exercise
    click_on "Stop"
    
    # Check that it returned to initial state
    assert_selector ".breathing-instruction", text: "Ready to breathe"
    assert_selector ".breathing-timer", text: "00:00"
  end

  test "can adjust breathing settings" do
    visit breathing_exercises_url
    
    # Check default values
    assert_selector "[data-breathing-exercise-target='inhaleDisplay']", text: "3s"
    assert_selector "[data-breathing-exercise-target='exhaleDisplay']", text: "3s"
    
    # Adjust inhale duration
    find("#inhale-duration").set(4)
    assert_selector "[data-breathing-exercise-target='inhaleDisplay']", text: "4s"
    
    # Adjust exhale duration
    find("#exhale-duration").set(6)
    assert_selector "[data-breathing-exercise-target='exhaleDisplay']", text: "6s"
  end

  test "can select breathing patterns" do
    visit breathing_exercises_url
    
    # Select box breathing pattern
    select "Box Breathing (4-4-4-4)", from: "breathing-pattern"
    
    # Check that sliders updated
    assert_selector "[data-breathing-exercise-target='inhaleDisplay']", text: "4s"
    assert_selector "[data-breathing-exercise-target='exhaleDisplay']", text: "4s"
  end

  test "can toggle reduced motion setting" do
    visit breathing_exercises_url
    
    # Check that reduced motion checkbox exists
    assert_selector "input[type='checkbox'][data-breathing-exercise-target='reduceMotion']"
    
    # Toggle the setting
    check "Reduce motion"
    assert_checked_field "Reduce motion"
    
    uncheck "Reduce motion"
    assert_unchecked_field "Reduce motion"
  end

  test "keyboard shortcuts work" do
    visit breathing_exercises_url
    
    # Use spacebar to start
    page.send_keys(:space)
    sleep(0.5)
    assert_selector ".breathing-instruction", text: /Breathe (in|out)\.\.\./
    
    # Use spacebar to pause
    page.send_keys(:space)
    sleep(0.5)
    
    # Use escape to stop
    page.send_keys(:escape)
    assert_selector ".breathing-instruction", text: "Ready to breathe"
  end

  test "page is responsive" do
    visit breathing_exercises_url
    
    # Test mobile viewport
    page.driver.browser.manage.window.resize_to(375, 667)
    assert_selector ".breathing-container"
    
    # Test desktop viewport
    page.driver.browser.manage.window.resize_to(1920, 1080)
    assert_selector ".breathing-container"
  end

  test "accessibility features are present" do
    visit breathing_exercises_url
    
    # Check for ARIA labels
    assert_selector "[aria-label]"
    assert_selector "[aria-live]"
    
    # Check for semantic HTML
    assert_selector "main"
    assert_selector "header"
    assert_selector "section"
    
    # Check for keyboard navigation
    assert_selector "button[aria-label]"
    assert_selector "input[aria-describedby]"
  end
end 