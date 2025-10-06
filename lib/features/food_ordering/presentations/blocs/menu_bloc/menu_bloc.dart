import 'package:bloc/bloc.dart';
import 'package:food_ordering_app/features/food_ordering/domain/entities/menu_item_entity.dart';
import 'menu_event.dart';
import 'menu_state.dart';
import '../../../data/mock_data/mock_menu_items.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuInitial()) {
    
    // Handle LoadMenuEvent
    on<LoadMenuEvent>((event, emit) async {
      emit(MenuLoading());
      
      try {
        await Future.delayed(const Duration(seconds: 1));
        
        // Get menu based on restaurant
        List<MenuItem> menuItems = _getMenuForRestaurant(event.restaurant.name);
        
        // Categorize menu items
        Map<String, List<MenuItem>> categorizedMenu = _categorizeMenu(menuItems);
        
        emit(MenuLoaded(
          restaurant: event.restaurant,
          menuItems: menuItems,
          categorizedMenu: categorizedMenu,
        ));
      } catch (e) {
        emit(MenuError('Failed to load menu: $e'));
      }
    });

    // Handle UpdateCartCountEvent
    on<UpdateCartCountEvent>((event, emit) {
      if (state is MenuLoaded) {
        final currentState = state as MenuLoaded;
        emit(currentState.copyWith(cartItemCount: event.count));
      }
    });

    // Handle FilterMenuByCategoryEvent
    on<FilterMenuByCategoryEvent>((event, emit) {
      if (state is MenuLoaded) {
        final currentState = state as MenuLoaded;
        
        if (event.category == 'All') {
          // Show all items
          final categorizedMenu = _categorizeMenu(currentState.menuItems);
          emit(currentState.copyWith(categorizedMenu: categorizedMenu));
        } else {
          // Filter by category
          final filteredItems = currentState.menuItems
              .where((item) => _getItemCategory(item) == event.category)
              .toList();
          
          final categorizedMenu = {event.category: filteredItems};
          emit(currentState.copyWith(categorizedMenu: categorizedMenu));
        }
      }
    });
  }

  // Helper method to get menu based on restaurant
  List<MenuItem> _getMenuForRestaurant(String restaurantName) {
    switch (restaurantName) {
      case 'Pizza Palace':
        return MockMenuItems.getPizzaPalaceMenu();
      case 'Burger Hub':
        return MockMenuItems.getBurgerHubMenu();
      case 'Sushi Sensei':
        return MockMenuItems.getPizzaPalaceMenu(); // Reusing for demo
      case 'Spice Garden':
        return MockMenuItems.getBurgerHubMenu(); // Reusing for demo
      case 'Dragon Wok':
        return MockMenuItems.getPizzaPalaceMenu(); // Reusing for demo
      case 'Taco Fiesta':
        return MockMenuItems.getBurgerHubMenu(); // Reusing for demo
      default:
        return MockMenuItems.getPizzaPalaceMenu();
    }
  }

  // Helper method to categorize menu items
  Map<String, List<MenuItem>> _categorizeMenu(List<MenuItem> menuItems) {
    final categories = <String, List<MenuItem>>{};
    
    for (var item in menuItems) {
      final category = _getItemCategory(item);
      if (!categories.containsKey(category)) {
        categories[category] = [];
      }
      categories[category]!.add(item);
    }
    
    return categories;
  }

  // Helper method to determine item category based on name/description
  String _getItemCategory(MenuItem item) {
    final name = item.name.toLowerCase();
    
    if (name.contains('pizza')) return 'Pizzas';
    if (name.contains('burger')) return 'Burgers';
    if (name.contains('sushi')) return 'Sushi';
    if (name.contains('taco')) return 'Tacos';
    if (name.contains('curry')) return 'Curries';
    if (name.contains('noodle')) return 'Noodles';
    if (name.contains('rice')) return 'Rice Dishes';
    if (name.contains('appetizer') || name.contains('starter')) return 'Starters';
    if (name.contains('dessert')) return 'Desserts';
    if (name.contains('drink') || name.contains('beverage')) return 'Beverages';
    
    return 'Main Course';
  }
}