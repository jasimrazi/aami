import 'package:aami/models/product_model.dart';
import 'package:aami/services/favourite_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteProvider with ChangeNotifier {
  final FavouriteService favouritesService = FavouriteService();
  List<int> favouriteProductIds = [];
  List<Product> favouriteProducts = [];
  bool isLoading = false;

  FavouriteProvider() {
    _loadFavouriteProductIds();
  }

  // Toggle the favourite status of a product
  Future<void> toggleFavourite(String loginid, int productid) async {
    isLoading = true;
    notifyListeners();

    try {
      final message = await favouritesService.addToFav(loginid, productid);
      print(message);

      if (message == "Product added to favourites") {
        favouriteProductIds.add(productid);
      } else if (message == "Product removed from favourites") {
        favouriteProductIds.remove(productid);
        // Remove product from favouriteProducts list as well
        favouriteProducts.removeWhere((product) => product.id == productid);
      }

      await _saveFavouriteProductIds();
    } catch (e) {
      print("Error toggling favourite: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch all favourite products for the user
  Future<void> fetchFavouriteProducts(String loginid) async {
    isLoading = true;
    notifyListeners();

    try {
      await _loadFavouriteProductIds();
      favouriteProducts = await favouritesService.fetchFavourites(loginid);

      // Ensure favourite IDs align with fetched products
      favouriteProductIds =
          favouriteProducts.map((product) => product.id).toList();
      await _saveFavouriteProductIds();
    } catch (e) {
      print("Error fetching favourite products: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Check if a product is in favourites
  bool isFavourite(int productid) {
    return favouriteProductIds.contains(productid);
  }

  // Save favourite product IDs to SharedPreferences
  Future<void> _saveFavouriteProductIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'favouriteProductIds',
      favouriteProductIds.map((id) => id.toString()).toList(),
    );
  }

  // Load favourite product IDs from SharedPreferences
  Future<void> _loadFavouriteProductIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedIds = prefs.getStringList('favouriteProductIds');
    if (savedIds != null) {
      favouriteProductIds = savedIds.map((id) => int.parse(id)).toList();
      notifyListeners();
    }
  }
}
