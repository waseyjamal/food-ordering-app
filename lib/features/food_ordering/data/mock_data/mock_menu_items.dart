import '../../domain/entities/menu_item_entity.dart';

class MockMenuItems {
  static List<MenuItem> getPizzaPalaceMenu() {
    return [
      MenuItem(
        id: 'p1',
        name: 'Margherita Pizza',
        description: 'Classic pizza with tomato sauce, mozzarella, and fresh basil',
        price: 399.0,
        imageUrl: 'https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?w=400&q=80',
        foodType: FoodType.veg,
        customizations: { // CHANGED to Map
          'Extra Cheese': false,
          'Thin Crust': false,
          'Stuffed Crust': false,
        },
        preparationTime: 20,
      ),
      MenuItem(
        id: 'p2',
        name: 'Pepperoni Pizza',
        description: 'Spicy pepperoni with mozzarella cheese and tomato sauce',
        price: 499.0,
        imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400&q=80',
        foodType: FoodType.nonVeg,
        customizations: { // CHANGED to Map
          'Extra Pepperoni': false,
          'Double Cheese': false,
          'Spicy': false,
        },
        preparationTime: 25,
      ),
      // Update all other menu items similarly...
    ];
  }

  static List<MenuItem> getBurgerHubMenu() {
    return [
      MenuItem(
        id: 'b1',
        name: 'Classic Cheese Burger',
        description: 'Beef patty with cheese, lettuce, tomato, and special sauce',
        price: 199.0,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
        foodType: FoodType.nonVeg,
        customizations: { // CHANGED to Map
          'Extra Patty': false,
          'Bacon': false,
          'Extra Cheese': false,
        },
        preparationTime: 15,
      ),
      // Update other items...
    ];
  }
}