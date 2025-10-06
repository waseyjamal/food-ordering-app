import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ordering_app/app/routes.dart';
import 'package:food_ordering_app/features/food_ordering/domain/entities/cart_item_entity.dart';
import '../blocs/cart_bloc/cart_bloc.dart';
import '../blocs/cart_bloc/cart_event.dart';
import '../blocs/cart_bloc/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.cartItems.isNotEmpty) {
                return IconButton(
                  onPressed: () {
                    context.read<CartBloc>().add(ClearCartEvent());
                  },
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Clear Cart',
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitial || state is CartLoading) {
            return _buildLoadingState();
          } else if (state is CartEmpty) {
            return _buildEmptyState(context);
          } else if (state is CartLoaded) {
            return _buildCartContent(context, state);
          } else if (state is CartError) {
            return _buildErrorState(context, state);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading your cart...'),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Add some delicious items to get started!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Go back to restaurant list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Browse Restaurants'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartLoaded state) {
    return Column(
      children: [
        // Cart Items List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.cartItems.length,
            itemBuilder: (context, index) {
              return _buildCartItemCard(context, state.cartItems[index]);
            },
          ),
        ),

        // Order Summary
        _buildOrderSummary(state),

        // Checkout Button
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              print('🟢 DEBUG: Checkout button pressed'); 
              // ✅ NEW: Navigate to Address Screen (Step 1 of checkout)
              Navigator.pushNamed(context, AppRoutes.address);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Proceed to Checkout',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem cartItem) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  cartItem.menuItem.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.fastfood,
                        color: Colors.grey[400],
                        size: 24,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Food Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        cartItem.menuItem.foodTypeSymbol,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          cartItem.menuItem.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cartItem.menuItem.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${(cartItem.menuItem.price * cartItem.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Quantity Controls
            Column(
              children: [
                // Quantity Display and Controls
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Decrease Button
                      IconButton(
                        onPressed: () {
                          if (cartItem.quantity > 1) {
                            context.read<CartBloc>().add(
                              UpdateCartItemQuantityEvent(
                                itemId: cartItem.menuItem.id,
                                newQuantity: cartItem.quantity - 1,
                              ),
                            );
                          } else {
                            context.read<CartBloc>().add(
                              RemoveFromCartEvent(itemId: cartItem.menuItem.id), // ✅ FIXED
                            );
                          }
                        },
                        icon: const Icon(Icons.remove, size: 18),
                        padding: const EdgeInsets.all(4),
                      ),

                      // Quantity
                      SizedBox(
                        width: 30,
                        child: Text(
                          cartItem.quantity.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      // Increase Button
                      IconButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                            UpdateCartItemQuantityEvent(
                              itemId: cartItem.menuItem.id,
                              newQuantity: cartItem.quantity + 1,
                            ),
                          );
                        },
                        icon: const Icon(Icons.add, size: 18),
                        padding: const EdgeInsets.all(4),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Remove Button
                TextButton(
                  onPressed: () {
                    context.read<CartBloc>().add(
                      RemoveFromCartEvent(itemId: cartItem.menuItem.id), // ✅ FIXED
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: const Text(
                    'Remove',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartLoaded state) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              'Subtotal (${state.itemCount} items)',
              '₹${state.subtotal.toStringAsFixed(2)}',
            ),
            _buildSummaryRow(
              'Delivery Fee',
              '₹${state.deliveryFee.toStringAsFixed(2)}',
            ),
            _buildSummaryRow('Tax (5%)', '₹${state.tax.toStringAsFixed(2)}'),
            const Divider(height: 24),
            _buildSummaryRow(
              'Total',
              '₹${state.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.deepPurple : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.deepPurple : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, CartError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          const Text(
            'Failed to load cart',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<CartBloc>().add(LoadCartEvent());
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}