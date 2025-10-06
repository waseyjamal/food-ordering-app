import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class LoadAddressesEvent extends AddressEvent {}

class AddAddressEvent extends AddressEvent {
  final String name;
  final String phone;
  final String house;
  final String area;
  final String landmark;
  final String city;
  final String pincode;
  final String type;

  const AddAddressEvent({
    required this.name,
    required this.phone,
    required this.house,
    required this.area,
    required this.landmark,
    required this.city,
    required this.pincode,
    required this.type,
  });

  @override
  List<Object> get props => [name, phone, house, area, landmark, city, pincode, type];
}

class UpdateAddressEvent extends AddressEvent {
  final String addressId;
  final String name;
  final String phone;
  final String house;
  final String area;
  final String landmark;
  final String city;
  final String pincode;
  final String type;

  const UpdateAddressEvent({
    required this.addressId,
    required this.name,
    required this.phone,
    required this.house,
    required this.area,
    required this.landmark,
    required this.city,
    required this.pincode,
    required this.type,
  });

  @override
  List<Object> get props => [addressId, name, phone, house, area, landmark, city, pincode, type];
}

class DeleteAddressEvent extends AddressEvent {
  final String addressId;

  const DeleteAddressEvent(this.addressId);

  @override
  List<Object> get props => [addressId];
}

class SetDefaultAddressEvent extends AddressEvent {
  final String addressId;

  const SetDefaultAddressEvent(this.addressId);

  @override
  List<Object> get props => [addressId];
}