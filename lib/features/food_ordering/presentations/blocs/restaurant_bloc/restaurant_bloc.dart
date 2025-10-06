import 'package:bloc/bloc.dart';
import 'package:food_ordering_app/features/food_ordering/data/mock_data/mock_restaurants.dart';
import 'package:food_ordering_app/features/food_ordering/domain/entities/restaurant_entity.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  List<Restaurant> _allRestaurants = []; // Store original list
  
  RestaurantBloc() : super(RestaurantInitial()) {
    
    // Handle LoadRestaurantsEvent
    on<LoadRestaurantsEvent>((event, emit) async {
      emit(RestaurantLoading());
      
      try {
        await Future.delayed(const Duration(seconds: 1)); // Reduced for better UX
        
        // Get fresh data and store it
        _allRestaurants = MockRestaurants.getRestaurants();
        
        emit(RestaurantLoaded(_allRestaurants));
      } catch (e) {
        emit(RestaurantError('Failed to load restaurants: $e'));
      }
    });

    // Handle SearchRestaurantsEvent - FIXED REAL-TIME SEARCH
    on<SearchRestaurantsEvent>((event, emit) {
      // If we haven't loaded restaurants yet, load them first
      if (_allRestaurants.isEmpty) {
        add(LoadRestaurantsEvent());
        return;
      }
      
      final searchQuery = event.query.trim();
      
      if (searchQuery.isEmpty) {
        // If search is empty, show all restaurants
        emit(RestaurantLoaded(_allRestaurants));
      } else {
        // Filter from original list based on search query
        final filteredRestaurants = _allRestaurants
            .where((restaurant) => 
                restaurant.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                restaurant.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
                restaurant.category.displayName.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
        
        emit(RestaurantLoaded(filteredRestaurants));
      }
    });

    // Handle FilterByCategoryEvent
    on<FilterByCategoryEvent>((event, emit) {
      if (_allRestaurants.isEmpty) {
        add(LoadRestaurantsEvent());
        return;
      }
      
      if (event.category == 'All') {
        emit(RestaurantLoaded(_allRestaurants));
      } else {
        final filteredRestaurants = _allRestaurants
            .where((restaurant) => 
                restaurant.category.displayName == event.category)
            .toList();
        
        emit(RestaurantLoaded(filteredRestaurants));
      }
    });
  }
}