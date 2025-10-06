import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/features/food_ordering/domain/entities/address_entity.dart';

@immutable
abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<AddressEntity> addresses;
  final AddressEntity? selectedAddress;

  const AddressLoaded({
    required this.addresses,
    this.selectedAddress,
  });

  @override
  List<Object> get props => [addresses, selectedAddress ?? ''];

  AddressLoaded copyWith({
    List<AddressEntity>? addresses,
    AddressEntity? selectedAddress,
  }) {
    return AddressLoaded(
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
    );
  }
}

class AddressError extends AddressState {
  final String message;

  const AddressError(this.message);

  @override
  List<Object> get props => [message];
}

class AddressAdded extends AddressState {
  final AddressEntity address;

  const AddressAdded(this.address);

  @override
  List<Object> get props => [address];
}

class AddressUpdated extends AddressState {
  final AddressEntity address;

  const AddressUpdated(this.address);

  @override
  List<Object> get props => [address];
}

class AddressDeleted extends AddressState {
  final String addressId;

  const AddressDeleted(this.addressId);

  @override
  List<Object> get props => [addressId];
}