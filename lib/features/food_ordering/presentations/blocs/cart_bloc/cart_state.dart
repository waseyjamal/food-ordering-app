import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/cart_item_entity.dart';

@immutable
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final int itemCount;

  const CartLoaded({
    required this.cartItems,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.itemCount,
  });

  @override
  List<Object> get props => [cartItems, subtotal, deliveryFee, tax, total, itemCount];

  CartLoaded copyWith({
    List<CartItem>? cartItems,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? total,
    int? itemCount,
  }) {
    return CartLoaded(
      cartItems: cartItems ?? this.cartItems,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      itemCount: itemCount ?? this.itemCount,
    );
  }
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}

class CartEmpty extends CartState {}