import 'package:equatable/equatable.dart';
import 'menu_item_entity.dart';

class CartItem extends Equatable {
  final MenuItem menuItem;
  final int quantity;
  final String? specialInstructions;
  final Map<String, bool> selectedCustomizations;

  const CartItem({
    required this.menuItem,
    this.quantity = 1,
    this.specialInstructions,
    this.selectedCustomizations = const {},
  });

  double get totalPrice => menuItem.price * quantity;

  CartItem copyWith({
    int? quantity,
    String? specialInstructions,
    Map<String, bool>? selectedCustomizations,
  }) {
    return CartItem(
      menuItem: menuItem,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      selectedCustomizations: selectedCustomizations ?? this.selectedCustomizations,
    );
  }

  @override
  List<Object?> get props => [
        menuItem,
        quantity,
        specialInstructions,
        selectedCustomizations,
      ];
}