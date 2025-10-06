import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/menu_item_entity.dart';

@immutable
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final MenuItem menuItem;
  final int quantity;
  final String specialInstructions;
  final Map<String, bool> customizations; // CHANGED to Map<String, bool>

  const AddToCartEvent({
    required this.menuItem,
    this.quantity = 1,
    this.specialInstructions = '',
    this.customizations = const {}, // CHANGED to empty map
  });

  @override
  List<Object> get props => [menuItem, quantity, specialInstructions, customizations];
}

class UpdateCartItemQuantityEvent extends CartEvent {
  final String itemId;
  final int newQuantity;

  const UpdateCartItemQuantityEvent({
    required this.itemId,
    required this.newQuantity,
  });

  @override
  List<Object> get props => [itemId, newQuantity];
}

class RemoveFromCartEvent extends CartEvent {
  final String itemId;

  const RemoveFromCartEvent({required this.itemId});

  @override
  List<Object> get props => [itemId];
}

class ClearCartEvent extends CartEvent {}