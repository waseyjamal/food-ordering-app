# 🍕 Food Ordering App - Flutter BLoC Assignment
> A beautifully designed food ordering app demonstrating BLoC architecture, SOLID principles, and scalable Flutter development practices.

![Flutter](https://img.shields.io/badge/Flutter-Framework-blue)
![BLoC](https://img.shields.io/badge/BLoC-Architecture-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## 📚 Table of Contents
- [📱 App Screenshots](#-app-screenshots)
- [🎯 Features](#-features)
- [🏗️ Architecture](#-architecture)
- [🛠️ Installation & Setup](#-installation--setup)
- [🔄 Workflow Overview](#-workflow-overview)
- [🎨 Design System](#-design-system)
- [📋 BLoC Implementation](#-bloc-implementation)
- [📝 Assignment Requirements Check](#-assignment-requirements-check)
- [👨‍💻 Developer](#-developer)

---

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

---

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

---

## 🏗️ Architecture

### BLoC Pattern Implementation
The project follows a **BLoC (Business Logic Component)** structure ensuring complete separation between UI and logic layers.

### SOLID Principles Applied
- **Single Responsibility** - Each BLoC handles a specific domain  
- **Open/Closed** - Extensible without modification  
- **Liskov Substitution** - Proper inheritance hierarchy  
- **Interface Segregation** - Focused interfaces  
- **Dependency Inversion** - Abstraction-based dependencies  

---

## 🛠️ Installation & Setup

### Prerequisites
- Flutter SDK 3.0+  
- Dart 2.17+  
- Android Studio / VS Code  

### Installation Steps
```bash
# 1. Clone the repository
git clone https://github.com/waseyjamal/food-ordering-app.git
cd food-ordering-app

# 2. Install dependencies
flutter pub get

# 3. Run the application
flutter run

# 4. Build for production
flutter build apk --release
flutter build ios --release

# 5. Run tests
flutter test

👨‍💻 Developer

Name: Wasey Jamal
Role: Flutter Developer
Email: waseyjamal@gmail.com

GitHub: @waseyjamal
