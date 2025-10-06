# 🍕 Food Ordering App - Flutter BLoC Assignment

A complete food ordering workflow built with Flutter using BLoC architecture, following SOLID principles and professional development practices.

## 📱 App Screenshots

### Home & Restaurant Flow
<div align="center">
  <img src="https://github.com/waseyjamal/food-ordering-app/raw/main/1.jpg" width="30%" alt="Home Screen"/>
  <img src="https://github.com/waseyjamal/food-ordering-app/raw/main/2.jpg" width="30%" alt="Restaurant List"/>
  <img src="https://github.com/waseyjamal/food-ordering-app/raw/main/3.jpg" width="30%" alt="Restaurant Search"/>
</div>

### Menu & Cart Management
<div align="center">
  <img src="https://github.com/waseyjamal/food-ordering-app/raw/main/4.jpg" width="30%" alt="Menu Screen"/>
  <img src="https://github.com/waseyjamal/food-ordering-app/raw/main/5.jpg" width="30%" alt="Food Details"/>
  <img src="https://github.com/waseyjamal/food-ordering-app/raw/main/6.jpg" width="30%" alt="Cart Screen"/>
</div>

### Checkout Process
<div align="center">
  <img src="https://github.com/waseyjamal/food-ordering-app/raw/main/7.jpg" width="30%" alt="Address Screen"/>
  <img src="https://github.com/waseyjamal/food-ordering-app/raw/main/8.jpg" width="30%" alt="Payment Screen"/>
  <img src="https://github.com/waseyjamal/food-ordering-app/raw/main/9.jpg" width="30%" alt="Order Review"/>
</div>

### Order Completion
<div align="center">
  <img src="https://github.com/waseyjamal/food-ordering-app/raw/main/10.jpg" width="30%" alt="Order Confirmation"/>
</div>

## 🎯 Features

### Core Functionality
- **Restaurant Listing** - Browse local restaurants with search and filters
- **Menu Management** - View categorized menu items with detailed descriptions
- **Cart System** - Add/remove items, quantity controls, real-time price calculation
- **3-Step Checkout** - Address → Payment → Order Confirmation
- **Order Tracking** - Complete order lifecycle management

### Technical Features
- **BLoC State Management** - Consistent across all screens
- **Responsive Design** - Optimized for mobile, tablet, and desktop
- **Error Handling** - Comprehensive error states and loading indicators
- **Clean Architecture** - Proper separation of concerns
- **Mock Data Integration** - Realistic food ordering simulation

## 🏗️ Architecture

### BLoC Pattern Implementation
Presentation Layer
├── Blocs (State Management)
├── Pages (Screens)
└── Widgets (Reusable Components)

Domain Layer
├── Entities (Data Models)
└── Services (Business Logic)

Data Layer
└── Mock Data (Sample Data)

text

### SOLID Principles Applied
- **Single Responsibility** - Each BLoC handles specific domain
- **Open/Closed** - Extensible without modification
- **Liskov Substitution** - Proper inheritance hierarchy
- **Interface Segregation** - Focused interfaces
- **Dependency Inversion** - Abstraction-based dependencies

## 🛠️ Installation & Setup

### Prerequisites
- Flutter SDK 3.0+
- Dart 2.17+
- Android Studio / VS Code

### Installation Steps
1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/food-ordering-app.git
   cd food-ordering-app
Install dependencies

bash
flutter pub get
Run the application

bash
flutter run
Building for Production
bash
flutter build apk --release
flutter build ios --release
🧪 Testing
Run Unit Tests
bash
flutter test
Test Coverage
BLoC state management tests

Cart functionality tests

Address management tests

Error handling tests


test/
└── features/food_ordering/bloc/  # Unit tests
🔄 Workflow Overview
User Journey
Home Screen - Browse restaurants with search and category filters

Menu Screen - View restaurant menu, add items to cart

Cart Screen - Review items, modify quantities, proceed to checkout

Address Screen - Enter delivery address

Payment Screen - Select payment method, review order

Confirmation - Order success with tracking information

State Management Flow
text
Event → Bloc → State → UI Update
🎨 Design System
Color Palette
Primary: Deep Purple (#6B46C1)

Secondary: Amber (#F6AD55)

Background: Grey (#F7FAFC)

Text: Gray (#4A5568)

Typography
Headlines: Roboto Bold

Body: Roboto Regular

Captions: Roboto Light

📋 BLoC Implementation
Key BLoCs
RestaurantBloc - Manages restaurant listing and filtering

MenuBloc - Handles menu loading and categorization

CartBloc - Manages cart operations and calculations

AddressBloc - Handles address management

CheckoutBloc - Processes order placement

State Management Example
dart
// Event
AddToCartEvent(menuItem: item, quantity: 1)

// State Transition
CartInitial → CartLoading → CartLoaded

// UI Update
CartLoaded(cartItems: updatedItems, total: calculatedTotal)
🚀 Features Demonstration
Real-time Search
Instant restaurant search with debouncing

Category-based filtering

Empty state handling

Cart Management
Add/remove items with quantity controls

Real-time price calculations

Persistent cart state

Checkout Process
Multi-step form validation

Order summary with breakdown

Success confirmation

🔧 Technical Highlights
Responsive Design
Adaptive layouts for different screen sizes

Mobile-first approach with tablet/desktop enhancements

Orientation handling

Error Handling
Network error states

Empty data states

User-friendly error messages

Retry mechanisms

Performance Optimizations
Efficient BLoC state management

Minimal widget rebuilds

Optimized image loading

Memory management

📝 Assignment Requirements Check
✅ BLoC Architecture - Consistent implementation across all screens
✅ Realistic Workflow - Complete food ordering experience
✅ Error Handling - Comprehensive error states and validation
✅ Aesthetic Design - Professional UI/UX with smooth animations
✅ SOLID Principles - Clean architecture with proper separation
✅ Unit Tests - BLoC and business logic testing
✅ Mock Data - Realistic restaurant and menu data

🤝 Contributing
Fork the repository

Create feature branch (git checkout -b feature/AmazingFeature)

Commit changes (git commit -m 'Add AmazingFeature')

Push to branch (git push origin feature/AmazingFeature)

Open Pull Request

📄 License
This project is created as part of a Flutter internship assignment.

👨‍💻 Developer
Name: Wasey Jamal

Email: waseyjamal000@gmail.com

GitHub: https://github.com/waseyjamal
