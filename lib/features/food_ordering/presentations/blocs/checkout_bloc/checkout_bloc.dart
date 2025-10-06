import 'package:bloc/bloc.dart';
import 'package:food_ordering_app/features/food_ordering/domain/entities/cart_item_entity.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

// 🎯 BLOC: Processes events → emits states
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(CheckoutInitial()) {
    
    // 🎯 EVENT HANDLER 1: Load checkout data
    on<LoadCheckoutEvent>((event, emit) async {
      emit(CheckoutLoading()); // Show loading
      
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        
        // 📥 In real app, get data from CartBloc or API
        final mockCartItems = <CartItem>[];
        const double deliveryFee = 30.0;
        const double taxRate = 0.05;
        
        // 🧮 Calculate totals
        double subtotal = 0;
        for (var item in mockCartItems) {
          subtotal += item.totalPrice;
        }
        
        double tax = subtotal * taxRate;
        double total = subtotal + deliveryFee + tax;
        
        // ✅ Emit loaded state with data
        emit(CheckoutLoaded(
          cartItems: mockCartItems,
          subtotal: subtotal,
          deliveryFee: deliveryFee,
          tax: tax,
          total: total,
          deliveryAddress: 'Enter your delivery address',
        ));
      } catch (e) {
        emit(CheckoutError('Failed to load checkout: $e'));
      }
    });

    // 🎯 EVENT HANDLER 2: Change payment method
    on<SelectPaymentMethodEvent>((event, emit) {
      if (state is CheckoutLoaded) {
        final currentState = state as CheckoutLoaded;
        // 🛠️ Update only payment method (immutable)
        emit(currentState.copyWith(selectedPaymentMethod: event.paymentMethod));
      }
    });

    // 🎯 EVENT HANDLER 3: Update address
    on<UpdateDeliveryAddressEvent>((event, emit) {
      if (state is CheckoutLoaded) {
        final currentState = state as CheckoutLoaded;
        emit(currentState.copyWith(deliveryAddress: event.address));
      }
    });

    // 🎯 EVENT HANDLER 4: Place order
    on<PlaceOrderEvent>((event, emit) async {
      if (state is CheckoutLoaded) {
        final currentState = state as CheckoutLoaded;
        
        emit(CheckoutLoading()); // Show loading
        
        try {
          // ⏳ Simulate API call
          await Future.delayed(const Duration(seconds: 2));
          
          // 🆔 Generate order ID
          final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';
          
          // 🎉 Emit success state
          emit(OrderPlacedSuccess(
            orderId: orderId,
            totalAmount: currentState.total,
          ));
        } catch (e) {
          emit(CheckoutError('Failed to place order: $e'));
        }
      }
    });
  }
}