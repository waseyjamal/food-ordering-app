import 'package:equatable/equatable.dart';

enum FoodType { veg, nonVeg, vegan }

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final FoodType foodType;
  final bool isAvailable;
  final Map<String, bool> customizations; // CHANGED from List<String> to Map<String, bool>
  final int preparationTime; // in minutes

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.foodType,
    this.isAvailable = true,
    this.customizations = const {}, // CHANGED to empty map
    this.preparationTime = 15,
  });

  String get foodTypeSymbol {
    switch (foodType) {
      case FoodType.veg:
        return '🟢';
      case FoodType.nonVeg:
        return '🔴';
      case FoodType.vegan:
        return '🌱';
    }
  }

  String get formattedPrice => '₹$price';

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        imageUrl,
        foodType,
        isAvailable,
        customizations,
        preparationTime,
      ];
}