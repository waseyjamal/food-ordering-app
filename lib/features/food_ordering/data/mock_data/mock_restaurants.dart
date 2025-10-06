// lib/features/food_ordering/data/mock_data/mock_restaurants.dart
import 'package:food_ordering_app/core/constants/app_constants.dart';

import '../../domain/entities/restaurant_entity.dart';

class MockRestaurants {
  static List<Restaurant> getRestaurants() {
    return [
      Restaurant(
        id: '1',
        name: 'Pizza Palace',
        description: 'Authentic Italian pizzas with fresh ingredients',
        imageUrl:
            'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&q=80', // Working pizza image
        category: FoodCategory.pizza,
        rating: 4.7,
        reviewCount: 1247,
        deliveryTime: '25-35 min',
        deliveryFee: 30.0,
        isPromoted: true,
        promotionText: '20% OFF',
      ),
      Restaurant(
        id: '2',
        name: 'Burger Hub',
        description: 'Gourmet burgers with secret sauces',
        imageUrl:
            'https://images.unsplash.com/photo-1571091655789-405eb7a3a3a8?w=400&q=80', // Working burger image
        category: FoodCategory.burger,
        rating: 4.5,
        reviewCount: 892,
        deliveryTime: '20-30 min',
        deliveryFee: 25.0,
        isPromoted: false,
      ),
      Restaurant(
        id: '3',
        name: 'Sushi Sensei',
        description: 'Fresh sushi and Japanese delicacies',
        imageUrl:
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400&q=80', // Working sushi image
        category: FoodCategory.sushi,
        rating: 4.8,
        reviewCount: 567,
        deliveryTime: '35-45 min',
        deliveryFee: 40.0,
        isPromoted: true,
        promotionText: 'Free Delivery',
      ),
      Restaurant(
        id: '4',
        name: 'Spice Garden',
        description: 'Authentic Indian curries and biryanis',
        imageUrl:
            'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400&q=80', // Working indian food image
        category: FoodCategory.indian,
        rating: 4.6,
        reviewCount: 723,
        deliveryTime: '30-40 min',
        deliveryFee: 35.0,
        isPromoted: false,
      ),
      Restaurant(
        id: '5',
        name: 'Dragon Wok',
        description: 'Chinese stir-fries and noodles',
        imageUrl:
            'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400&q=80', // Working chinese food image
        category: FoodCategory.chinese,
        rating: 4.3,
        reviewCount: 445,
        deliveryTime: '25-35 min',
        deliveryFee: 30.0,
        isPromoted: true,
        promotionText: 'Buy 1 Get 1',
      ),
      Restaurant(
        id: '6',
        name: 'Taco Fiesta',
        description: 'Mexican street food and tacos',
        imageUrl:
            'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=400&q=80', // Working taco image
        category: FoodCategory.mexican,
        rating: 4.4,
        reviewCount: 389,
        deliveryTime: '20-30 min',
        deliveryFee: 25.0,
        isPromoted: false,
      ),
    ];
  }
}
