import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/restaurant_entity.dart';

@immutable
abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class LoadMenuEvent extends MenuEvent {
  final Restaurant restaurant;

  const LoadMenuEvent(this.restaurant);

  @override
  List<Object> get props => [restaurant];
}

class UpdateCartCountEvent extends MenuEvent {
  final int count;

  const UpdateCartCountEvent(this.count);

  @override
  List<Object> get props => [count];
}

class FilterMenuByCategoryEvent extends MenuEvent {
  final String category;

  const FilterMenuByCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}