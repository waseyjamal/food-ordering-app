import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ordering_app/features/food_ordering/domain/entities/menu_item_entity.dart';
import 'package:food_ordering_app/features/food_ordering/domain/entities/restaurant_entity.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/cart_bloc/cart_state.dart';
import '../blocs/menu_bloc/menu_bloc.dart';
import '../blocs/menu_bloc/menu_event.dart' as menu_events;
import '../blocs/menu_bloc/menu_state.dart';
import '../blocs/cart_bloc/cart_bloc.dart';
import '../blocs/cart_bloc/cart_event.dart';
import '../widgets/food_detail_bottom_sheet.dart';
import 'package:food_ordering_app/app/routes.dart';

class MenuScreen extends StatelessWidget {
  final Restaurant restaurant;

  const MenuScreen({super.key, required this.restaurant});

  void _showFoodDetailBottomSheet(BuildContext context, MenuItem menuItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FoodDetailBottomSheet(menuItem: menuItem);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc()..add(menu_events.LoadMenuEvent(restaurant)),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                restaurant.description,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                final cartCount = state is CartLoaded ? state.itemCount : 0;
                return Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.cart);
                      },
                      icon: const Icon(Icons.shopping_cart),
                    ),
                    if (cartCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            cartCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<MenuBloc, MenuState>(
          builder: (context, state) {
            if (state is MenuInitial || state is MenuLoading) {
              return _buildLoadingState();
            } else if (state is MenuLoaded) {
              return _buildMenuContent(context, state);
            } else if (state is MenuError) {
              return _buildErrorState(context, state);
            }
            return const SizedBox();
          },
        ),
        // ✅ PROPER FLOATING CART BAR - SMALL BAR AT BOTTOM
        bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded && state.itemCount > 0) {
              return _buildFloatingCartBar(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading menu...'),
        ],
      ),
    );
  }

  Widget _buildMenuContent(BuildContext context, MenuLoaded state) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(16),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      state.restaurant.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.deepPurple[100],
                          child: Icon(
                            Icons.restaurant,
                            color: Colors.deepPurple,
                            size: 30,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.restaurant.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.restaurant.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            state.restaurant.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' • ${state.restaurant.deliveryInfo}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        _buildCategoryTabs(state),

        Expanded(
          child: _buildMenuItemsList(state),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs(MenuLoaded state) {
    final categories = ['All', ...state.categorizedMenu.keys.toList()];
    
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              onSelected: (selected) {
                context.read<MenuBloc>().add(menu_events.FilterMenuByCategoryEvent(category));
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.deepPurple,
              labelStyle: const TextStyle(fontSize: 12),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItemsList(MenuLoaded state) {
    final menuItems = state.categorizedMenu.values.expand((list) => list).toList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final menuItem = menuItems[index];
        return _buildMenuItemCard(context, menuItem);
      },
    );
  }

  Widget _buildMenuItemCard(BuildContext context, MenuItem menuItem) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // ✅ TAP CARD: Open bottom sheet with food details
          _showFoodDetailBottomSheet(context, menuItem);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    menuItem.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.fastfood,
                          color: Colors.grey[400],
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          menuItem.foodTypeSymbol,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            menuItem.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      menuItem.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          menuItem.formattedPrice,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${menuItem.preparationTime} min',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // ✅ + BUTTON: Direct add 1 item to cart - FIXED
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  onPressed: () {
                    // ✅ DIRECT ADD 1 ITEM TO CART - FIXED WITH customizations PARAMETER
                    context.read<CartBloc>().add(AddToCartEvent(
                      menuItem: menuItem,
                      quantity: 1,
                      customizations: {}, // ← ADDED THIS LINE
                    ));
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ PROPER FLOATING CART BAR - SMALL BAR AT BOTTOM
  Widget _buildFloatingCartBar(BuildContext context, CartLoaded state) {
    return Container(
      height: 70, // Fixed height for small bar
      margin: const EdgeInsets.all(16), // Creates floating effect
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Cart Icon
          const Icon(
            Icons.shopping_cart_rounded,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          
          // Quantity Badge
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                state.itemCount.toString(),
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Item Count and Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${state.itemCount} ${state.itemCount == 1 ? 'item' : 'items'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹${state.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // View Cart Button
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.cart);
              },
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.deepPurple,
                size: 16,
              ),
              label: const Text(
                'View Cart',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, MenuError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load menu',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<MenuBloc>().add(menu_events.LoadMenuEvent(restaurant));
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}