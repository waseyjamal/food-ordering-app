// lib/features/food_ordering/presentation/blocs/restaurant_bloc/restaurant_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart'; // Add this import for @immutable
import 'package:food_ordering_app/features/food_ordering/domain/entities/restaurant_entity.dart';

// Base state
@immutable
abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object> get props => [];
}

// Initial state - when app starts
class RestaurantInitial extends RestaurantState {}

// Loading state - when fetching data
class RestaurantLoading extends RestaurantState {}

// Loaded state - when we have data
class RestaurantLoaded extends RestaurantState {
  final List<Restaurant> restaurants;
  const RestaurantLoaded(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

// Error state - when something goes wrong
class RestaurantError extends RestaurantState {
  final String message;
  const RestaurantError(this.message);

  @override
  List<Object> get props => [message];
}