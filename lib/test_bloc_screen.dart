// lib/test_bloc_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ordering_app/app/routes.dart';
import 'package:food_ordering_app/core/constants/app_constants.dart';
import 'package:food_ordering_app/core/utils/responsive_utils.dart';
import 'package:food_ordering_app/features/food_ordering/domain/entities/restaurant_entity.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/cart_bloc/cart_bloc.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/cart_bloc/cart_state.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/restaurant_bloc/restaurant_bloc.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/restaurant_bloc/restaurant_event.dart';
import 'package:food_ordering_app/features/food_ordering/presentations/blocs/restaurant_bloc/restaurant_state.dart';

class TestBlocScreen extends StatelessWidget {
  const TestBlocScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodExpress 🍕'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Cart Icon for Home Screen
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveUtils.getResponsivePadding(context),
          ),
          child: Column(
            children: [
              // Search Bar - Responsive
              _buildSearchBar(context),
              SizedBox(height: ResponsiveUtils.getResponsivePadding(context)),
              // Category Filter with GestureDetector
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                behavior: HitTestBehavior.opaque,
                child: _buildCategoryFilter(context),
              ),
              SizedBox(height: ResponsiveUtils.getResponsivePadding(context)),
              // Restaurant List
              Expanded(
                child: BlocBuilder<RestaurantBloc, RestaurantState>(
                  builder: (context, state) {
                    return _buildContent(context, state);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<RestaurantBloc>().add(LoadRestaurantsEvent());
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.refresh),
        tooltip: 'Reload Restaurants',
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      width: ResponsiveUtils.getResponsiveWidth(context),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search restaurants...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (query) {
          context.read<RestaurantBloc>().add(SearchRestaurantsEvent(query));
        },
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    final categories = [
      'All',
      'Pizza',
      'Burger',
      'Sushi',
      'Indian',
      'Chinese',
      'Mexican',
    ];

    if (ResponsiveUtils.isMobile(context)) {
      return SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildCategoryChip(context, categories[index]),
            );
          },
        ),
      );
    } else {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: categories.map((category) {
          return _buildCategoryChip(context, category);
        }).toList(),
      );
    }
  }

  Widget _buildCategoryChip(BuildContext context, String category) {
    return FilterChip(
      label: Text(
        category,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      onSelected: (selected) {
        FocusScope.of(context).unfocus(); // Close keyboard when chip is tapped
        context.read<RestaurantBloc>().add(FilterByCategoryEvent(category));
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.deepPurple,
      labelStyle: TextStyle(color: Colors.grey[800]),
      checkmarkColor: Colors.white,
    );
  }

  // ... REST OF YOUR CODE REMAINS EXACTLY THE SAME ...
  // Keep all other methods exactly as they were in your previous code
  Widget _buildContent(BuildContext context, RestaurantState state) {
    if (state is RestaurantInitial) {
      return _buildInitialState(context);
    } else if (state is RestaurantLoading) {
      return _buildLoadingState(context);
    } else if (state is RestaurantLoaded) {
      return _buildRestaurantList(context, state.restaurants);
    } else if (state is RestaurantError) {
      return _buildErrorState(context, state);
    }
    return const SizedBox();
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: ResponsiveUtils.isMobile(context) ? 80 : 120,
            color: Colors.deepPurple[200],
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome to FoodExpress!',
            style: TextStyle(
              fontSize: ResponsiveUtils.isMobile(context) ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Discover the best restaurants in your area',
            style: TextStyle(
              fontSize: ResponsiveUtils.isMobile(context) ? 14 : 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              context.read<RestaurantBloc>().add(LoadRestaurantsEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.isMobile(context) ? 32 : 48,
                vertical: ResponsiveUtils.isMobile(context) ? 16 : 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Explore Restaurants',
              style: TextStyle(
                fontSize: ResponsiveUtils.isMobile(context) ? 16 : 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: ResponsiveUtils.isMobile(context) ? 40 : 60,
            height: ResponsiveUtils.isMobile(context) ? 40 : 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading restaurants...',
            style: TextStyle(
              fontSize: ResponsiveUtils.isMobile(context) ? 16 : 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantList(
    BuildContext context,
    List<Restaurant> restaurants,
  ) {
    if (restaurants.isEmpty) {
      return _buildEmptyState(context);
    }

    if (ResponsiveUtils.isMobile(context)) {
      return ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          return _buildRestaurantCard(context, restaurants[index]);
        },
      );
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveUtils.getGridCrossAxisCount(context),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: ResponsiveUtils.isTablet(context) ? 1.2 : 1.4,
        ),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          return _buildRestaurantCard(context, restaurants[index]);
        },
      );
    }
  }

  Widget _buildRestaurantCard(BuildContext context, Restaurant restaurant) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          FocusScope.of(context).unfocus(); // Close keyboard before navigation
          Navigator.pushNamed(context, AppRoutes.menu, arguments: restaurant);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    restaurant.imageUrl,
                    height: isMobile ? 150 : 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: isMobile ? 150 : 160,
                        color: Colors.deepPurple[100],
                        child: Icon(
                          _getCategoryIcon(restaurant.category),
                          size: 40,
                          color: Colors.deepPurple,
                        ),
                      );
                    },
                  ),
                ),
                if (restaurant.isPromoted)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        restaurant.promotionText!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: isMobile ? 16 : 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.rating.toString(),
                            style: TextStyle(
                              fontSize: isMobile ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.description,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: isMobile ? 14 : 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.deliveryInfo,
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${restaurant.reviewCount} reviews',
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          color: Colors.grey[600],
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
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: ResponsiveUtils.isMobile(context) ? 80 : 120,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No restaurants found',
            style: TextStyle(
              fontSize: ResponsiveUtils.isMobile(context) ? 18 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Try adjusting your search or filter',
            style: TextStyle(
              fontSize: ResponsiveUtils.isMobile(context) ? 14 : 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, RestaurantError state) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: ResponsiveUtils.isMobile(context) ? 80 : 120,
              color: Colors.red[300],
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: ResponsiveUtils.isMobile(context) ? 18 : 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              state.message,
              style: TextStyle(
                fontSize: ResponsiveUtils.isMobile(context) ? 14 : 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.read<RestaurantBloc>().add(LoadRestaurantsEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.isMobile(context) ? 24 : 32,
                  vertical: ResponsiveUtils.isMobile(context) ? 12 : 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(FoodCategory category) {
    switch (category) {
      case FoodCategory.pizza:
        return Icons.local_pizza;
      case FoodCategory.burger:
        return Icons.fastfood;
      case FoodCategory.sushi:
        return Icons.set_meal;
      case FoodCategory.indian:
        return Icons.restaurant;
      case FoodCategory.chinese:
        return Icons.rice_bowl;
      case FoodCategory.mexican:
        return Icons.local_dining;
      default:
        return Icons.restaurant_menu;
    }
  }
}
