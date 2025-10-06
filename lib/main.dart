import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ordering_app/features/food_ordering/domain/entities/restaurant_entity.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/address_bloc/address_bloc.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/cart_bloc/cart_bloc.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/cart_bloc/cart_event.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/menu_bloc/menu_bloc.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/menu_bloc/menu_event.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/restaurant_bloc/restaurant_bloc.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/pages/address_screen.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/pages/cart_screen.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/pages/menu_screen.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/pages/order_confirmation_screen.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/pages/payment_screen.dart';
import 'test_bloc_screen.dart';
import 'app/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RestaurantBloc()),
        BlocProvider(create: (context) => CartBloc()..add(LoadCartEvent())),
      ],
      child: MaterialApp(
        title: 'Food Ordering App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          AppRoutes.restaurantList: (context) => const TestBlocScreen(),
          AppRoutes.menu: (context) {
            final restaurant =
                ModalRoute.of(context)!.settings.arguments as Restaurant;
            return BlocProvider(
              create: (context) => MenuBloc()..add(LoadMenuEvent(restaurant)),
              child: MenuScreen(restaurant: restaurant),
            );
          },
          AppRoutes.cart: (context) => const CartScreen(),
          AppRoutes.address: (context) => BlocProvider(
            // ✅ THIS MUST EXIST
            create: (context) => AddressBloc(),
            child: const AddressScreen(),
          ),
          AppRoutes.payment: (context) => const PaymentScreen(),
          AppRoutes.orderConfirmation: (context) =>
              const OrderConfirmationScreen(),
        },
        initialRoute: AppRoutes.restaurantList,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
