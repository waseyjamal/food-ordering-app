import 'package:bloc/bloc.dart';
import 'package:food_ordering_app/features/food_ordering/domain/entities/menu_item_entity.dart';
import 'package:food_ordering_app/features/food_ordering/domain/entities/cart_item_entity.dart';
import 'package:food_ordering_app/features/food_ordering/domain/services/price_calculator.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  List<CartItem> _cartItems = [];

  CartBloc() : super(CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemQuantityEvent>(_onUpdateQuantity);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) {
    try {
      if (_cartItems.isEmpty) {
        emit(CartEmpty());
      } else {
        final calculations = PriceCalculator.calculateTotals(_cartItems);
        emit(_buildLoadedState(calculations));
      }
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    try {
      _validateMenuItem(event.menuItem);
      
      final existingIndex = _cartItems.indexWhere(
        (item) => item.menuItem.id == event.menuItem.id,
      );

      if (existingIndex >= 0) {
        _updateExistingItem(existingIndex, event.quantity);
      } else {
        _addNewItem(event);
      }

      _emitLoadedState(emit);
    } catch (e) {
      emit(CartError('Failed to add item: ${e.toString()}'));
    }
  }

  void _onUpdateQuantity(UpdateCartItemQuantityEvent event, Emitter<CartState> emit) {
    try {
      if (event.newQuantity < 0) {
        throw ArgumentError('Quantity cannot be negative');
      }

      final itemIndex = _cartItems.indexWhere(
        (item) => item.menuItem.id == event.itemId,
      );

      if (itemIndex == -1) {
        throw StateError('Cart item not found');
      }

      if (event.newQuantity == 0) {
        _cartItems.removeAt(itemIndex);
      } else {
        final existingItem = _cartItems[itemIndex];
        _cartItems[itemIndex] = existingItem.copyWith(
          quantity: event.newQuantity,
        );
      }

      if (_cartItems.isEmpty) {
        emit(CartEmpty());
      } else {
        _emitLoadedState(emit);
      }
    } catch (e) {
      emit(CartError('Failed to update quantity: ${e.toString()}'));
    }
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    try {
      final initialLength = _cartItems.length;
      _cartItems.removeWhere((item) => item.menuItem.id == event.itemId);
      
      if (_cartItems.length == initialLength) {
        throw StateError('Item not found in cart');
      }

      if (_cartItems.isEmpty) {
        emit(CartEmpty());
      } else {
        _emitLoadedState(emit);
      }
    } catch (e) {
      emit(CartError('Failed to remove item: ${e.toString()}'));
    }
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    _cartItems.clear();
    emit(CartEmpty());
  }

  // Helper methods
  void _validateMenuItem(MenuItem menuItem) {
    if (menuItem.price <= 0) {
      throw ArgumentError('Invalid menu item price');
    }
  }

  void _updateExistingItem(int index, int additionalQuantity) {
    final existingItem = _cartItems[index];
    _cartItems[index] = existingItem.copyWith(
      quantity: existingItem.quantity + additionalQuantity,
    );
  }

  void _addNewItem(AddToCartEvent event) {
    final newCartItem = CartItem(
      menuItem: event.menuItem,
      quantity: event.quantity,
      specialInstructions: event.specialInstructions,
      selectedCustomizations: event.customizations,
    );
    _cartItems.add(newCartItem);
  }

  void _emitLoadedState(Emitter<CartState> emit) {
    final calculations = PriceCalculator.calculateTotals(_cartItems);
    emit(_buildLoadedState(calculations));
  }

  CartLoaded _buildLoadedState(Map<String, dynamic> calculations) {
    return CartLoaded(
      cartItems: List.from(_cartItems),
      subtotal: calculations['subtotal'] as double,
      deliveryFee: calculations['deliveryFee'] as double,
      tax: calculations['tax'] as double,
      total: calculations['total'] as double,
      itemCount: calculations['itemCount'] as int,
    );
  }
}