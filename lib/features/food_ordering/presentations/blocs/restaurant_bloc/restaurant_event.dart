// lib/features/food_ordering/presentation/blocs/restaurant_bloc/restaurant_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart'; // Add this import

// Base class for all events
@immutable
abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object> get props => [];
}

// Event when we want to load restaurants
class LoadRestaurantsEvent extends RestaurantEvent {
  const LoadRestaurantsEvent();
}

// Event when user searches for restaurants
class SearchRestaurantsEvent extends RestaurantEvent {
  final String query;
  const SearchRestaurantsEvent(this.query);

  @override
  List<Object> get props => [query];
}

// Event when user filters by category
class FilterByCategoryEvent extends RestaurantEvent {
  final String category;
  const FilterByCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}