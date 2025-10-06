import '../entities/cart_item_entity.dart';

class PriceCalculator {
  static const double deliveryFee = 30.0;
  static const double taxRate = 0.05;

  static Map<String, dynamic> calculateTotals(List<CartItem> items) {
    double subtotal = 0;
    int itemCount = 0;

    for (var item in items) {
      subtotal += item.totalPrice;
      itemCount += item.quantity;
    }

    double tax = subtotal * taxRate;
    double total = subtotal + deliveryFee + tax;

    return {
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'total': total,
      'itemCount': itemCount,
    };
  }
}