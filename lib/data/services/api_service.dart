import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  final http.Client _client;
  static const String baseUrl = 'https://fakestoreapi.com/products';

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _client.get(Uri.parse(baseUrl)).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ApiException('Failed to load products (HTTP ${response.statusCode})');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error occurred: ${e.toString()}');
    }
  }
}
