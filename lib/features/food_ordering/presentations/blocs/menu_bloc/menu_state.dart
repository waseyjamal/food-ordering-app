import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/menu_item_entity.dart';
import '../../../domain/entities/restaurant_entity.dart';

@immutable
abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final Restaurant restaurant;
  final List<MenuItem> menuItems;
  final Map<String, List<MenuItem>> categorizedMenu;
  final int cartItemCount;

  const MenuLoaded({
    required this.restaurant,
    required this.menuItems,
    required this.categorizedMenu,
    this.cartItemCount = 0,
  });

  @override
  List<Object> get props => [restaurant, menuItems, categorizedMenu, cartItemCount];

  MenuLoaded copyWith({
    Restaurant? restaurant,
    List<MenuItem>? menuItems,
    Map<String, List<MenuItem>>? categorizedMenu,
    int? cartItemCount,
  }) {
    return MenuLoaded(
      restaurant: restaurant ?? this.restaurant,
      menuItems: menuItems ?? this.menuItems,
      categorizedMenu: categorizedMenu ?? this.categorizedMenu,
      cartItemCount: cartItemCount ?? this.cartItemCount,
    );
  }
}

class MenuError extends MenuState {
  final String message;

  const MenuError(this.message);

  @override
  List<Object> get props => [message];
}