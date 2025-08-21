# Wellio Stress Management

A modern, accessible web application designed to help kids manage stress through guided breathing exercises. Built with a focus on simplicity, accessibility, and immediate relief from stress and anxiety.

## 🎯 Project Purpose

provides an intuitive, web-based breathing exercise tool that helps users:

- **Reduce Stress & Anxiety**: Guided breathing patterns designed to activate the parasympathetic nervous system
- **Improve Focus**: Structured breathing exercises to enhance concentration and mental clarity
- **Promote Relaxation**: Calming visual and audio elements combined with proven breathing techniques
- **Accessible Wellness**: No registration required - immediate access to stress relief tools

The application features a "Wizard Breathing School" theme that makes stress management approachable and engaging for users of all ages.

## 🛠 Tech Stack

### Backend
- **Ruby on Rails 8.0.2** - Modern web framework with convention over configuration
- **SQLite3** - Lightweight database for development and testing
- **Puma** - High-performance web server
- **Solid Cache/Queue/Cable** - Database-backed caching, job processing, and real-time features

### Frontend
- **Hotwire (Turbo + Stimulus)** - Modern JavaScript framework for dynamic interactions
- **Import Maps** - Native ES6 module support without bundlers
- **CSS3 Animations** - Smooth, synchronized breathing visualizations
- **Web Audio API** - Calming background sounds and audio feedback

### Development & Deployment
- **Docker** - Containerized deployment with Kamal
- **Brakeman** - Security vulnerability scanning
- **RuboCop** - Code quality and style enforcement
- **Capybara** - System testing framework

## 🏗 Architecture

### Application Structure

```
wellio-stress-management/
├── app/
│   ├── controllers/
│   │   └── breathing_exercises_controller.rb    # Public wellness endpoint
│   ├── services/
│   │   └── breathing_exercise_service.rb        # Business logic for breathing patterns
│   ├── views/
│   │   └── breathing_exercises/
│   │       └── index.html.erb                   # Main breathing interface
│   ├── javascript/
│   │   └── controllers/
│   │       └── breathing_exercise_controller.js # Interactive breathing logic
│   └── assets/
│       ├── stylesheets/
│       │   └── breathing_exercises.css          # Breathing exercise styling
│       └── sounds/
│           └── water.mp3                        # Calming background audio
```

### Key Components

#### 1. Breathing Exercise Service
- **Purpose**: Encapsulates breathing pattern calculations and validation
- **Features**:
  - Configurable inhale/exhale durations (2-8 seconds)
  - Pre-defined breathing patterns (Box, 4-7-8, Equal, Relaxing)
  - Health pattern validation to prevent hyperventilation
  - Session recommendations based on breathing speed

#### 2. Stimulus Controller
- **Purpose**: Manages real-time breathing exercise interactions
- **Features**:
  - Synchronized visual animations with breathing cycles
  - Audio integration with calming water sounds
  - Real-time instruction updates
  - Session timing and progress tracking

#### 3. Public Wellness Interface
- **Purpose**: Provides immediate access to stress relief tools
- **Features**:
  - No authentication required
  - Responsive design for all devices
  - Accessibility-focused with ARIA labels
  - Progressive Web App (PWA) capabilities

### Data Flow

1. **User Access**: Direct access to breathing exercises via root route
2. **Pattern Configuration**: Service layer validates and configures breathing patterns
3. **Real-time Interaction**: Stimulus controller manages synchronized animations and audio
4. **Visual Feedback**: CSS animations provide immediate visual breathing guidance
5. **Audio Enhancement**: Background sounds create a calming environment

### Security & Performance

- **Security Headers**: XSS protection, content type options, frame options
- **Error Handling**: Graceful degradation with user-friendly error messages
- **Performance**: Optimized animations using Web Animations API
- **Accessibility**: WCAG compliant with screen reader support

## 🚀 Getting Started

### Prerequisites
- Ruby 3.0+
- Rails 8.0.2
- Node.js (for import maps)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd wellio-stress-management
   ```

2. **Install dependencies**
   ```bash
   bundle install
   rails s
   ```

5. **Visit the application**
   ```
   http://localhost:3000
   ```

## 📞 Support

For support and questions, please open an issue in the GitHub repository.

---

**Built with ❤️ for better mental health and stress management for wellio**
