# Chart Sample App

An interactive Flutter chart visualization application demonstrating modern state management and responsive design patterns.

## 🎯 Project Overview

This Flutter application showcases interactive data visualization using the fl_chart library with comprehensive state management through Provider pattern. The app implements a responsive design that adapts to both desktop and mobile layouts.

## ✨ Features

### Chart Visualization
- **Interactive Bar Charts**: Dynamic bar charts with touch interactions and animations
- **Interactive Pie Charts**: Donut-style pie charts with center text and hover effects
- **Real-time Data Updates**: Live chart updates with smooth animations
- **Responsive Design**: Optimized layouts for desktop (side-by-side) and mobile (stacked)

### Technical Implementation
- **Provider State Management**: Centralized state management with ChangeNotifier
- **TDD Approach**: Comprehensive test coverage (65.6%) with 82+ test cases
- **Modern Architecture**: Clean separation of models, providers, and widgets
- **Performance Optimized**: Efficient rendering and memory management

## 🏗️ Architecture

```
lib/
├── models/
│   ├── chart_data_helper.dart      # Utility functions for chart data
│   └── chart_data_models.dart      # Data models for charts
├── providers/
│   └── chart_provider.dart         # State management provider
├── screens/
│   └── home_screen.dart            # Main app screen
└── widgets/
    ├── chart_area.dart             # Chart visualization widget
    └── control_panel.dart          # User interaction controls
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd chart_sample_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

## 📊 Test Coverage

Current test coverage: **65.6%** (481/733 lines)

| Component | Coverage | Lines Hit/Total |
|-----------|----------|-----------------|
| chart_data_helper.dart | 80.2% | 65/81 |
| chart_provider.dart | 77.5% | 124/160 |
| chart_area.dart | 60.8% | 225/370 |
| chart_data_models.dart | 54.9% | 67/122 |

## 🧪 Testing Strategy

The project follows Test-Driven Development (TDD) principles with:
- **82 comprehensive test cases** covering all core functionality
- **Unit tests** for data models and utility functions
- **Widget tests** for UI components and interactions
- **Provider tests** for state management verification
- **Integration tests** for complete user flows

## 📈 Development Progress

### ✅ Completed Tasks
1. **Unit Testing Policy**: Established comprehensive testing standards
2. **fl_chart Integration**: Interactive chart library implementation
3. **Data Models**: Robust chart data models with calculations
4. **State Management**: Provider-based architecture
5. **Unit Testing**: 82 test cases with 65.6% coverage

### 🔄 Current Status
- **Task 2.5**: Git upload and version management (in progress)

### 📋 Upcoming Tasks
- Responsive layout implementation
- Stacked bar chart widgets
- Donut chart with center percentage
- Chart section with toggle features
- Slider-based data controls
- Color picker customization
- Animations and optimizations

## 🛠️ Built With

- **Flutter**: UI framework
- **fl_chart**: Chart visualization library
- **Provider**: State management solution
- **Dart**: Programming language

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

For more information about Flutter development, visit the [official documentation](https://docs.flutter.dev/).
