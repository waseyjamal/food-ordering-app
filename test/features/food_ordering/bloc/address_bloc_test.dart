import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/address_bloc/address_bloc.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/address_bloc/address_event.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/address_bloc/address_state.dart';

void main() {
  group('AddressBloc', () {
    late AddressBloc addressBloc;

    setUp(() {
      addressBloc = AddressBloc();
    });

    tearDown(() {
      addressBloc.close();
    });

    blocTest<AddressBloc, AddressState>(
      'emits [AddressLoading, AddressLoaded] when LoadAddressesEvent',
      build: () => addressBloc,
      act: (bloc) => bloc.add(LoadAddressesEvent()),
      expect: () => [
        AddressLoading(),
        isA<AddressLoaded>()
          .having((state) => state.addresses.length, 'addresses length', 0)
      ],
    );

    blocTest<AddressBloc, AddressState>(
      'emits [AddressAdded, AddressLoaded] when AddAddressEvent',
      build: () => addressBloc,
      act: (bloc) => bloc.add(AddAddressEvent(
        name: 'John Doe',
        phone: '1234567890',
        house: '123 Main St',
        area: 'Downtown',
        landmark: 'Near Park',
        city: 'Test City',
        pincode: '123456',
        type: 'Home',
      )),
      expect: () => [
        isA<AddressAdded>(),
        isA<AddressLoaded>()
          .having((state) => state.addresses.length, 'addresses length', 1)
          .having((state) => state.selectedAddress?.name, 'name', 'John Doe')
      ],
    );
  });
}