import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ordering_app/core/utils/responsive_utils.dart';
import 'package:food_ordering_app/app/routes.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/cart_bloc/cart_state.dart';
import '../blocs/cart_bloc/cart_bloc.dart';
import '../blocs/cart_bloc/cart_event.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';
            final totalAmount = cartState is CartLoaded ? cartState.total : 0.0;

            return _buildConfirmationContent(
              context,
              orderId,
              totalAmount,
              cartState is CartLoaded ? cartState.cartItems.length : 0,
            );
          },
        ),
      ),
    );
  }

  Widget _buildConfirmationContent(
    BuildContext context,
    String orderId,
    double totalAmount,
    int itemCount,
  ) {
    return SingleChildScrollView(
      // ✅ ADDED SCROLLVIEW
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height, // ✅ ENSURE FULL HEIGHT
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🎉 Success Icon
            Icon(
              Icons.check_circle,
              size: ResponsiveUtils.isMobile(context)
                  ? 60
                  : 80, // ✅ RESPONSIVE SIZE
              color: Colors.green,
            ),
            const SizedBox(height: 20),

            // ✅ Order Confirmed Text
            Text(
              'Order Confirmed!',
              style: TextStyle(
                fontSize: ResponsiveUtils.isMobile(context)
                    ? 24
                    : 28, // ✅ RESPONSIVE FONT
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            Text(
              'Thank you for your order',
              style: TextStyle(
                fontSize: ResponsiveUtils.isMobile(context)
                    ? 16
                    : 18, // ✅ RESPONSIVE FONT
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 📦 Order Details Card
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.isMobile(context)
                    ? 8
                    : 0, // ✅ RESPONSIVE MARGIN
              ),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // 🆔 Order ID
                      _buildDetailRow('Order ID', orderId),
                      const SizedBox(height: 10),

                      // 📅 Order Date
                      _buildDetailRow(
                        'Order Date',
                        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      ),
                      const SizedBox(height: 10),

                      // ⏰ Estimated Delivery
                      _buildDetailRow('Estimated Delivery', '30-40 minutes'),
                      const SizedBox(height: 10),

                      // 🛒 Items Count
                      _buildDetailRow('Items', '$itemCount items'),
                      const SizedBox(height: 10),

                      // 💰 Total Amount
                      _buildDetailRow(
                        'Total Amount',
                        '₹${totalAmount.toStringAsFixed(2)}',
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🏠 Delivery Address
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.isMobile(context)
                    ? 8
                    : 0, // ✅ RESPONSIVE MARGIN
              ),
              child: _buildDeliveryAddress(),
            ),
            const SizedBox(height: 24),

            // 🔄 Track Order Button
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.isMobile(context)
                    ? 8
                    : 0, // ✅ RESPONSIVE MARGIN
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order tracking feature coming soon!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Track Your Order',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.isMobile(context)
                          ? 16
                          : 18, // ✅ RESPONSIVE FONT
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 🛍️ Continue Shopping Button
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.isMobile(context)
                    ? 8
                    : 0, // ✅ RESPONSIVE MARGIN
              ),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<CartBloc>().add(ClearCartEvent());
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.restaurantList,
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.deepPurple),
                  ),
                  child: Text(
                    'Continue Shopping',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.isMobile(context)
                          ? 14
                          : 16, // ✅ RESPONSIVE FONT
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
            ),

            // 📱 ADD EXTRA SPACING FOR MOBILE KEYBOARD
            if (ResponsiveUtils.isMobile(context)) const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 📝 WIDGET: Detail Row
  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? Colors.deepPurple : Colors.black,
          ),
        ),
      ],
    );
  }

  // 🏠 WIDGET: Delivery Address
  // 🏠 WIDGET: Delivery Address - COMPACT VERSION
  Widget _buildDeliveryAddress() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12), // ✅ REDUCED PADDING
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.deepPurple,
                  size: 18,
                ), // ✅ SMALLER ICON
                SizedBox(width: 6),
                Text(
                  'Delivery To',
                  style: TextStyle(
                    fontSize: 14, // ✅ SMALLER FONT
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 13, // ✅ SMALLER FONT
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '123 Main Street, Apartment 4B, Central Park West',
              style: TextStyle(fontSize: 12), // ✅ SMALLER FONT
              maxLines: 2, // ✅ PREVENT OVERFLOW
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'New York, NY 10025',
              style: TextStyle(fontSize: 12), // ✅ SMALLER FONT
            ),
            const SizedBox(height: 4),
            Text(
              'Phone: +1 234 567 8900',
              style: TextStyle(
                fontSize: 11, // ✅ SMALLER FONT
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
