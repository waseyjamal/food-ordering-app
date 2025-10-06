import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/cart_bloc/cart_bloc.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/cart_bloc/cart_event.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/cart_bloc/cart_state.dart';

void main() {
  group('CartBloc', () {
    late CartBloc cartBloc;
    
    setUp(() {
      cartBloc = CartBloc();
    });

    tearDown(() {
      cartBloc.close();
    });

    test('initial state is CartInitial', () {
      expect(cartBloc.state, isA<CartInitial>());
    });

    blocTest<CartBloc, CartState>(
      'emits [CartEmpty] when LoadCartEvent with empty cart',
      build: () => cartBloc,
      act: (bloc) => bloc.add(LoadCartEvent()),
      expect: () => [isA<CartEmpty>()],
    );
  });
}