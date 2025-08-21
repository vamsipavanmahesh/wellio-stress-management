import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "circle", 
    "instruction", 
    "timer",
    "startButton",
    "stopButton"
  ]

  static values = {
    defaultInhale: { type: Number, default: 4 },
    defaultExhale: { type: Number, default: 6 },
    minDuration: { type: Number, default: 2 },
    maxDuration: { type: Number, default: 10 }
  }

  connect() {
    console.log('Breathing exercise controller connecting...')
    this.initializeState()
    this.initializeAudio()
    // Don't start audio immediately - wait for user interaction
    this.updateButtonStates()
    
    if (this.hasInstructionTarget) {
      this.instructionTarget.textContent = 'Ready to learn magical breathing spells! ✨'
    }
    
    console.log('Breathing exercise controller connected successfully!')
  }

  initializeState() {
    this.isRunning = false
    this.startTime = null
    this.elapsedTime = 0
    this.inhaleMs = (this.defaultInhaleValue || 4) * 1000
    this.exhaleMs = (this.defaultExhaleValue || 6) * 1000
    this.animation = null
    this.timerInterval = null
    this.instructionInterval = null
    this.backgroundAudio = null
    this.breathingAudio = null
    this.audioStarted = false
  }

  initializeAudio() {
    // Create calming background audio using the water.mp3 file
    this.backgroundAudio = new Audio('/sounds/water.mp3')
    this.backgroundAudio.loop = true
    this.backgroundAudio.volume = 0.3
    this.backgroundAudio.preload = 'auto'
    
    // Add event listeners for debugging
    this.backgroundAudio.addEventListener('loadstart', () => console.log('Audio loading started'))
    this.backgroundAudio.addEventListener('canplay', () => console.log('Audio can play'))
    this.backgroundAudio.addEventListener('canplaythrough', () => console.log('Audio can play through'))
    this.backgroundAudio.addEventListener('error', (e) => console.error('Audio error:', e))
    
    // Create breathing guidance audio
    this.breathingAudio = new Audio()
    this.breathingAudio.volume = 0.5
    
    console.log('Audio initialized with water.mp3')
  }

  startBackgroundAudio() {
    if (!this.backgroundAudio) {
      console.log('No background audio available')
      return
    }

    try {
      // Play the water.mp3 file
      this.backgroundAudio.play().then(() => {
        console.log('Waterfall audio started successfully')
        this.audioStarted = true
      }).catch(error => {
        console.error('Failed to play waterfall audio:', error)
      })
      
    } catch (error) {
      console.error('Error starting background audio:', error)
    }
  }

  stopBackgroundAudio() {
    if (this.backgroundAudio) {
      // Fade out the audio
      const fadeOut = setInterval(() => {
        if (this.backgroundAudio.volume > 0.01) {
          this.backgroundAudio.volume -= 0.01
        } else {
          this.backgroundAudio.pause()
          this.backgroundAudio.currentTime = 0
          this.backgroundAudio.volume = 0.3 // Reset volume for next time
          clearInterval(fadeOut)
          this.audioStarted = false
          console.log('Waterfall audio stopped')
        }
      }, 50) // Fade out over ~1.5 seconds
    }
  }

  start() {
    console.log('Start method called!')
    
    if (this.isRunning) {
      console.log('Already running')
      return
    }

    console.log('Starting breathing exercise...')
    this.isRunning = true
    this.startTime = performance.now() - this.elapsedTime

    // Start audio on first user interaction
    if (!this.audioStarted) {
      this.startBackgroundAudio()
    }

    this.startBreathingAnimation()
    this.startTimer()
    this.startInstructionCycle()
    this.updateButtonStates()
    
    if (this.hasInstructionTarget) {
      this.instructionTarget.textContent = '🫁 Cast your magical breath in spell... 💚'
      this.instructionTarget.style.color = '#4CAF50'
    }
    
    console.log('Breathing exercise started successfully!')
  }

  stop() {
    console.log('Stopping breathing exercise...')
    
    this.isRunning = false
    this.elapsedTime = 0

    this.stopAnimation()
    this.stopTimer()
    this.stopInstructionCycle()
    this.stopBackgroundAudio() // Stop the waterfall sound
    this.resetInterface()
    this.updateButtonStates()
    
    console.log('Breathing exercise stopped')
  }

  startBreathingAnimation() {
    if (!this.hasCircleTarget) {
      console.log('No circle target found')
      return
    }

    const totalCycleDuration = this.inhaleMs + this.exhaleMs
    const inhaleRatio = this.inhaleMs / totalCycleDuration

    // Synchronized keyframes that match the breathing phases exactly
    const keyframes = [
      { 
        transform: 'scale(0.85)', 
        opacity: 0.75,
        offset: 0 
      },
      { 
        transform: 'scale(1.3)', 
        opacity: 1, 
        offset: inhaleRatio  // Circle reaches max size at end of inhale
      },
      { 
        transform: 'scale(0.85)', 
        opacity: 0.75, 
        offset: 1  // Circle returns to min size at end of exhale
      }
    ]

    // Use linear easing for precise timing control
    const options = {
      duration: totalCycleDuration,
      iterations: Infinity,
      easing: 'linear'  // Linear easing ensures precise timing
    }

    try {
      this.animation = this.circleTarget.animate(keyframes, options)
      console.log('Animation started with synchronized timing')
    } catch (error) {
      console.error('Animation failed:', error)
      this.startCSSAnimation()
    }
  }

  startCSSAnimation() {
    if (!this.hasCircleTarget) return
    
    // Synchronized CSS animation
    this.circleTarget.style.animation = `breathingPulseSynchronized ${(this.inhaleMs + this.exhaleMs) / 1000}s infinite linear`
  }

  stopAnimation() {
    if (this.animation) {
      this.animation.cancel()
      this.animation = null
    }
    
    if (this.hasCircleTarget) {
      this.circleTarget.style.animation = ''
      this.circleTarget.style.transform = 'scale(0.85)'
      this.circleTarget.style.opacity = '0.75'
    }
  }

  startTimer() {
    this.timerInterval = setInterval(() => {
      this.elapsedTime = performance.now() - this.startTime
      this.updateTimerDisplay()
    }, 100)
  }

  stopTimer() {
    if (this.timerInterval) {
      clearInterval(this.timerInterval)
      this.timerInterval = null
    }
  }

  updateTimerDisplay() {
    if (!this.hasTimerTarget) return
    
    const seconds = Math.floor(this.elapsedTime / 1000)
    const minutes = Math.floor(seconds / 60)
    const remainingSeconds = seconds % 60

    const timeString = `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`
    this.timerTarget.textContent = timeString
  }

  startInstructionCycle() {
    this.instructionInterval = setInterval(() => {
      if (!this.isRunning || !this.hasInstructionTarget) return

      const elapsed = (performance.now() - this.startTime) % (this.inhaleMs + this.exhaleMs)
      
      if (elapsed < this.inhaleMs) {
        this.instructionTarget.textContent = '🫁 Inhale slowly... 💚'
        this.instructionTarget.style.color = '#4CAF50'
      } else {
        this.instructionTarget.textContent = '💨 Exhale peacefully... 🔵'
        this.instructionTarget.style.color = '#2196F3'
      }
    }, 50) // More frequent updates for better synchronization
  }

  stopInstructionCycle() {
    if (this.instructionInterval) {
      clearInterval(this.instructionInterval)
      this.instructionInterval = null
    }
  }

  resetInterface() {
    if (this.hasInstructionTarget) {
      this.instructionTarget.textContent = 'Ready to learn magical breathing spells! ✨'
      this.instructionTarget.style.color = 'white'
    }
    
    if (this.hasTimerTarget) {
      this.timerTarget.textContent = '00:00'
    }
    
    if (this.hasCircleTarget) {
      this.circleTarget.style.transform = 'scale(0.85)'
      this.circleTarget.style.opacity = '0.75'
    }
  }

  updateButtonStates() {
    if (this.hasStartButtonTarget) {
      this.startButtonTarget.disabled = this.isRunning
      this.startButtonTarget.classList.toggle('btn--disabled', this.isRunning)
    }
    
    if (this.hasStopButtonTarget) {
      this.stopButtonTarget.disabled = !this.isRunning
      this.stopButtonTarget.classList.toggle('btn--active', this.isRunning)
    }
  }

  disconnect() {
    this.stop()
    if (this.backgroundAudio) {
      this.backgroundAudio.pause()
      this.backgroundAudio.currentTime = 0
      this.backgroundAudio = null
    }
    console.log('Breathing exercise controller disconnected')
  }
}