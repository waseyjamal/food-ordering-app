import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String house;
  final String area;
  final String landmark;
  final String city;
  final String pincode;
  final String type; // 'home', 'work', 'other'
  final bool isDefault;

  const AddressEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.house,
    required this.area,
    required this.landmark,
    required this.city,
    required this.pincode,
    this.type = 'home',
    this.isDefault = false,
  });

  String get fullAddress {
    return '$house, $area, $landmark, $city - $pincode';
  }

  @override
  List<Object> get props => [
        id,
        name,
        phone,
        house,
        area,
        landmark,
        city,
        pincode,
        type,
        isDefault,
      ];

  AddressEntity copyWith({
    String? id,
    String? name,
    String? phone,
    String? house,
    String? area,
    String? landmark,
    String? city,
    String? pincode,
    String? type,
    bool? isDefault,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      house: house ?? this.house,
      area: area ?? this.area,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}