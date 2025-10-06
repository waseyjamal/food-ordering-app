import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

// 🎯 EVENT: What user DOES
@immutable
abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

// 📥 EVENT 1: Load checkout page
class LoadCheckoutEvent extends CheckoutEvent {}

// 💳 EVENT 2: User selects payment method
class SelectPaymentMethodEvent extends CheckoutEvent {
  final String paymentMethod; // 'Credit Card', 'UPI', 'Cash'

  const SelectPaymentMethodEvent(this.paymentMethod);

  @override
  List<Object> get props => [paymentMethod];
}

// 🏠 EVENT 3: User updates delivery address
class UpdateDeliveryAddressEvent extends CheckoutEvent {
  final String address;

  const UpdateDeliveryAddressEvent(this.address);

  @override
  List<Object> get props => [address];
}

// ✅ EVENT 4: User places order
class PlaceOrderEvent extends CheckoutEvent {}