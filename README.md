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
- 🍽️ **Restaurant Listing** – Browse local restaurants with search and filters  
- 🧾 **Menu Management** – View categorized menu items with detailed descriptions  
- 🛒 **Cart System** – Add/remove items, control quantities, and see real-time price updates  
- 💳 **3-Step Checkout** – Address → Payment → Order Confirmation  
- 🚚 **Order Tracking** – Complete order lifecycle management  

### Technical Features
- ⚙️ **BLoC State Management** – Consistent across all screens  
- 📱 **Responsive Design** – Optimized for mobile, tablet, and desktop  
- 🚨 **Error Handling** – Full error states and loading indicators  
- 🧩 **Clean Architecture** – Proper separation of concerns  
- 🧠 **Mock Data Integration** – Realistic ordering simulation  

---

## 🏗️ Architecture

### 🧱 BLoC Pattern Implementation
This project follows a **BLoC (Business Logic Component)** structure to maintain separation of UI and business logic layers.  
UI updates reactively based on BLoC state streams — ensuring scalability and testability.

### 🧭 SOLID Principles Applied
- **Single Responsibility:** Each BLoC serves one domain (cart, menu, order).  
- **Open/Closed:** Easy to extend without modifying core logic.  
- **Liskov Substitution:** All model relationships maintain consistent behavior.  
- **Interface Segregation:** Small and focused repository/service interfaces.  
- **Dependency Inversion:** Uses abstraction layers for BLoCs and repositories.  

---

## 🛠️ Installation & Setup

### Prerequisites
- Flutter SDK 3.0+  
- Dart 2.17+  
- Android Studio / VS Code installed  

### Installation Steps
```bash
# 1. Clone the repository
git clone https://github.com/waseyjamal/food-ordering-app.git
cd food-ordering-app

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run

# 4. Build for production
flutter build apk --release
flutter build ios --release

# 5. Run tests
flutter test

🔄 Workflow Overview
Step	Action	Description
1️⃣	Open App	Displays home screen with search & categories
2️⃣	Select Restaurant	Loads restaurant menu and details
3️⃣	Add to Cart	Items are dynamically managed in cart
4️⃣	Checkout	User enters address and payment details
5️⃣	Confirm Order	Final confirmation with order summary
6️⃣	Order Completed	Confirmation screen and order tracking


📝 Assignment Requirements Check
Requirement	Description	Implemented
🧠 State Management	Used BLoC pattern throughout	✅
🧹 Clean Architecture	Followed SOLID principles	✅
🔀 Navigation Flow	Smooth and consistent navigation	✅
🍽️ Dynamic Data	Menu and restaurant data fetched via repositories	✅
🛒 Cart Handling	Real-time price, quantity update	✅
💳 Checkout	Multi-step with summary	✅
🧾 Code Readability	Structured and modular	✅
📱 Responsiveness	Works across devices	✅
👨‍💻 Developer

👤 Name: Wasey Jamal
💼 Role: Flutter Developer
📧 Email: waseyjamal@gmail.com

🌐 GitHub: @waseyjamal

📍 Location: India

Code Clean. Design Smart. Deliver Impact.
