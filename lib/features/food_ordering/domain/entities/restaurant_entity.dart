// lib/features/food_ordering/domain/entities/restaurant_entity.dart
import 'package:equatable/equatable.dart';
import 'package:food_ordering_app/core/constants/app_constants.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final FoodCategory category;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final double deliveryFee;
  final bool isPromoted;
  final String? promotionText;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    this.isPromoted = false,
    this.promotionText,
  });

  // Helper method to get rating text
  String get ratingText {
    if (rating >= 4.5) return RestaurantRating.excellent.displayName;
    if (rating >= 4.0) return RestaurantRating.veryGood.displayName;
    if (rating >= 3.5) return RestaurantRating.good.displayName;
    if (rating >= 3.0) return RestaurantRating.average.displayName;
    return RestaurantRating.poor.displayName;
  }

  // Helper method to get formatted delivery info
  String get deliveryInfo {
    return '$deliveryTime • ${AppConstants.currency}$deliveryFee delivery';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        category,
        rating,
        reviewCount,
        deliveryTime,
        deliveryFee,
        isPromoted,
        promotionText,
      ];
}