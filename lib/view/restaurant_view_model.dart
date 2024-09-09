import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_search_app/data/model/restaurant_model.dart';


// viewmodel using Riverpod
class RestaurantViewModel extends StateNotifier<List<RestaurantModel>> {

  //auto call function while using viewmodel
  RestaurantViewModel() : super([]) {
    _loadData();
  }

  //list of items
  List<RestaurantModel> _allRestaurant = [];


  // loading data from json
  Future<void> _loadData() async {
      final String response = await rootBundle.loadString('assets/restaurants.json');
      final List<dynamic> data = json.decode(response);
      _allRestaurant = data.map((json) => RestaurantModel.fromJson(json)).toList();
      state = _allRestaurant;
  }


  //search by name and cuisine
  void searchItem(String query) {
    if (query.isEmpty) {
      state = _allRestaurant;
    } else {
      state = _allRestaurant.where((element) {
        return element.name.toLowerCase().contains(query.toLowerCase()) ||
            element.cuisine.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }
}


// Set up Riverpod providers for showing data
final restaurantViewModelProvider =
    StateNotifierProvider<RestaurantViewModel, List<RestaurantModel>>(
  (ref) => RestaurantViewModel(),
);


//Set up Riverpod providers for filtering restaurant data
final searchQueryProvider = StateProvider((ref) => '');
