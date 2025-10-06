import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/features/food_ordering/domain/entities/cart_item_entity.dart';

// 🎯 STATE: What user SEES
@immutable
abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

// ⏳ STATE 1: Initial/loading state
class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

// ✅ STATE 2: Data loaded successfully
class CheckoutLoaded extends CheckoutState {
  final List<CartItem> cartItems;      // Cart items
  final double subtotal;               // Items total
  final double deliveryFee;            // Delivery charge
  final double tax;                    // Tax amount
  final double total;                  // Grand total
  final String selectedPaymentMethod;  // Chosen payment
  final String deliveryAddress;        // Delivery address

  const CheckoutLoaded({
    required this.cartItems,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    this.selectedPaymentMethod = 'Credit Card',
    this.deliveryAddress = '',
  });

  @override
  List<Object> get props => [
        cartItems,
        subtotal,
        deliveryFee,
        tax,
        total,
        selectedPaymentMethod,
        deliveryAddress,
      ];

  // 🛠️ METHOD: Create updated state (immutable)
  CheckoutLoaded copyWith({
    List<CartItem>? cartItems,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? total,
    String? selectedPaymentMethod,
    String? deliveryAddress,
  }) {
    return CheckoutLoaded(
      cartItems: cartItems ?? this.cartItems,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    );
  }
}

// ❌ STATE 3: Error occurred
class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object> get props => [message];
}

// 🎉 STATE 4: Order placed successfully
class OrderPlacedSuccess extends CheckoutState {
  final String orderId;
  final double totalAmount;

  const OrderPlacedSuccess({
    required this.orderId,
    required this.totalAmount,
  });

  @override
  List<Object> get props => [orderId, totalAmount];
}