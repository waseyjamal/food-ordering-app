import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ordering_app/core/utils/responsive_utils.dart';
import 'package:food_ordering_app/app/routes.dart';
import '../blocs/cart_bloc/cart_bloc.dart';
import '../blocs/cart_bloc/cart_state.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            if (cartState is CartLoaded) {
              return _buildPaymentContent(context, cartState);
            } else if (cartState is CartEmpty) {
              return _buildEmptyCartState(context);
            } else {
              return _buildLoadingState();
            }
          },
        ),
      ),
    );
  }

  // ✅ FIXED: Main payment content
  Widget _buildPaymentContent(BuildContext context, CartLoaded cartState) {
    return ListView(
      children: [
        // 🏠 Delivery Address Summary
        _buildAddressSection(context),
        const SizedBox(height: 24),
        
        // 📦 Order Summary
        _buildOrderSummary(context, cartState),
        const SizedBox(height: 24),
        
        // 💳 Payment Methods
        _buildPaymentMethodsSection(context),
        const SizedBox(height: 32),
        
        // ✅ Place Order Button
        _buildPlaceOrderButton(context, cartState),
      ],
    );
  }

  // 🏠 WIDGET: Delivery Address Section
  Widget _buildAddressSection(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.location_on, color: Colors.deepPurple, size: 20),
                SizedBox(width: 8),
                Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '123 Main Street, Apartment 4B',
              style: TextStyle(fontSize: 14),
            ),
            const Text(
              'Central Park West, New York',
              style: TextStyle(fontSize: 14),
            ),
            const Text(
              'NY 10025, United States',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.address);
              },
              child: const Text('Change Address'),
            ),
          ],
        ),
      ),
    );
  }

  // 📦 WIDGET: Order Summary Section
  Widget _buildOrderSummary(BuildContext context, CartLoaded cartState) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // 🛒 Cart Items
            ...cartState.cartItems.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.menuItem.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.fastfood,
                            color: Colors.grey[400],
                            size: 20,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.menuItem.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Quantity: ${item.quantity}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${(item.menuItem.price * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
            
            const Divider(height: 24),
            
            // 💰 Price Breakdown
            _buildPriceRow('Subtotal', cartState.subtotal),
            _buildPriceRow('Delivery Fee', cartState.deliveryFee),
            _buildPriceRow('Tax (5%)', cartState.tax),
            const Divider(height: 16),
            _buildPriceRow(
              'Total Amount',
              cartState.total,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  // 💰 WIDGET: Price Row
  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
            '₹${amount.toStringAsFixed(2)}',
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

  // 💳 WIDGET: Payment Methods Section (FIXED - No duplicate)
  Widget _buildPaymentMethodsSection(BuildContext context) {
    final paymentMethods = [
      {
        'id': 'upi',
        'name': 'UPI',
        'icon': Icons.phone_android,
        'description': 'Pay via UPI apps'
      },
      {
        'id': 'card',
        'name': 'Credit/Debit Card',
        'icon': Icons.credit_card,
        'description': 'Pay with card'
      },
      {
        'id': 'netbanking',
        'name': 'Net Banking',
        'icon': Icons.account_balance,
        'description': 'Internet banking'
      },
      {
        'id': 'cod',
        'name': 'Cash on Delivery',
        'icon': Icons.money,
        'description': 'Pay when delivered'
      },
    ];

    return StatefulBuilder(
      builder: (context, setState) {
        String selectedPaymentMethod = 'upi';

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                ...paymentMethods.map((method) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedPaymentMethod == method['id'] 
                            ? Colors.deepPurple 
                            : Colors.grey[300]!,
                        width: selectedPaymentMethod == method['id'] ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: Icon(
                        method['icon'] as IconData,
                        color: Colors.deepPurple,
                      ),
                      title: Text(method['name'] as String),
                      subtitle: Text(method['description'] as String),
                      trailing: Radio<String>(
                        value: method['id'] as String,
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          selectedPaymentMethod = method['id'] as String;
                        });
                      },
                    ),
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ WIDGET: Place Order Button
  Widget _buildPlaceOrderButton(BuildContext context, CartLoaded cartState) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.orderConfirmation);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Place Order',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ⏳ WIDGET: Loading State
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading payment...'),
        ],
      ),
    );
  }

  // 🛒 WIDGET: Empty Cart State
  Widget _buildEmptyCartState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text('Add some items to proceed to payment'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Browse Restaurants'),
          ),
        ],
      ),
    );
  }
}