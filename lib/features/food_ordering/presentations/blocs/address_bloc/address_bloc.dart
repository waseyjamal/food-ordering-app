import 'package:bloc/bloc.dart';
import 'package:food_ordering_app/features/food_ordering/domain/entities/address_entity.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  List<AddressEntity> _addresses = [];

  AddressBloc() : super(AddressInitial()) {
    on<LoadAddressesEvent>((event, emit) async {
      emit(AddressLoading());

      try {
        await Future.delayed(const Duration(milliseconds: 500));

        // In real app, this would come from database/API
        // For now, using empty list or mock data
        _addresses = []; // Start with empty

        emit(
          AddressLoaded(
            addresses: _addresses,
            selectedAddress: _addresses.isNotEmpty ? _addresses.first : null,
          ),
        );
      } catch (e) {
        emit(AddressError('Failed to load addresses: $e'));
      }
    });

    on<AddAddressEvent>((event, emit) async {
      if (state is AddressLoaded) {
        try {
          final newAddress = AddressEntity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: event.name,
            phone: event.phone,
            house: event.house,
            area: event.area,
            landmark: event.landmark,
            city: event.city,
            pincode: event.pincode,
            type: event.type,
            isDefault: _addresses.isEmpty, // First address is default
          );

          _addresses.add(newAddress);

          emit(AddressAdded(newAddress));
          emit(
            AddressLoaded(
              addresses: List.from(_addresses),
              selectedAddress: newAddress,
            ),
          );
        } catch (e) {
          emit(AddressError('Failed to add address: $e'));
        }
      }
    });

    on<SetDefaultAddressEvent>((event, emit) {
      if (state is AddressLoaded) {
        // ✅ REMOVED UNUSED VARIABLE - directly use the logic

        // Update all addresses - set only one as default
        final updatedAddresses = _addresses.map((address) {
          return address.copyWith(isDefault: address.id == event.addressId);
        }).toList();

        final selectedAddress = updatedAddresses.firstWhere(
          (address) => address.id == event.addressId,
        );

        _addresses = updatedAddresses;

        emit(
          AddressLoaded(
            addresses: List.from(_addresses),
            selectedAddress: selectedAddress,
          ),
        );
      }
    });
    on<DeleteAddressEvent>((event, emit) {
      if (state is AddressLoaded) {
        _addresses.removeWhere((address) => address.id == event.addressId);

        emit(AddressDeleted(event.addressId));
        emit(
          AddressLoaded(
            addresses: List.from(_addresses),
            selectedAddress: _addresses.isNotEmpty ? _addresses.first : null,
          ),
        );
      }
    });
  }
}
