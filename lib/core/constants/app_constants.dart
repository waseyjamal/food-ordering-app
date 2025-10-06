// lib/core/constants/app_constants.dart

class AppConstants {
  static const String appName = 'FoodExpress';
  
  // Currency symbol
  static const String currency = '₹';
  
  // Delivery fee
  static const double deliveryFee = 30.0;
  
  // Tax percentage
  static const double taxPercentage = 5.0;
}

// Food categories
enum FoodCategory {
  all('All'),
  pizza('Pizza'),
  burger('Burger'),
  sushi('Sushi'),
  mexican('Mexican'),
  indian('Indian'),
  chinese('Chinese'),
  desserts('Desserts'),
  drinks('Drinks');

  const FoodCategory(this.displayName);
  final String displayName;
}

// Restaurant ratings
enum RestaurantRating {
  poor(1, 'Poor'),
  average(2, 'Average'),
  good(3, 'Good'),
  veryGood(4, 'Very Good'),
  excellent(5, 'Excellent');

  const RestaurantRating(this.value, this.displayName);
  final int value;
  final String displayName;
}