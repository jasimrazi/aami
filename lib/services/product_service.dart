import 'dart:convert';
import 'package:aami/models/product_model.dart';
import 'package:aami/utils/url.dart';
import 'package:http/http.dart' as http;

class ProductService {
  // Method to fetch products
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      print("API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Check if 'data' is present and is a list
        if (jsonResponse['data'] != null && jsonResponse['data'] is List) {
          return Product.fromJsonList(jsonResponse); // Parse multiple products
        } else {
          print("Error: 'data' field is null or not a List in the response.");
          return [];
        }
      } else {
        throw Exception("Failed to load products: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching products: $e");
      throw Exception("Error fetching products: $e");
    }
  }

  Future<Product> fetchSingleProduct(int productID) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/products/$productID'));
      print("API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        print('service single product: $jsonResponse');
        // Log and handle the response as a single product
        print("Parsed Single Product Response: $jsonResponse");

        return Product.fromJson(jsonResponse); // This should return a Map for a single product
      } else {
        throw Exception("Failed to load product: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching single product: $e");
      throw Exception("Error fetching single product: $e");
    }
  }
}
