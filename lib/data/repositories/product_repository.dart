import '../models/product.dart';
import '../services/api_service.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<List<Product>> getProducts({bool forceRefresh = false}) async {
    try {
      final products = await _apiService.fetchProducts();
      if (products.isNotEmpty) {
        return products;
      }
    } catch (_) {
      // If network request fails, fall back to realistic offline mock dataset
    }
    return _getOfflineMockProducts();
  }

  // Realistic mock data fallback ensuring zero app breaking when offline
  List<Product> _getOfflineMockProducts() {
    return [
      Product.fromJson({
        'id': 1,
        'title': 'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops',
        'price': 109.95,
        'description':
            'Your everyday carry pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday essentials in the main compartment.',
        'category': "men's clothing",
        'image': 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
        'rating': {'rate': 3.9, 'count': 120}
      }),
      Product.fromJson({
        'id': 2,
        'title': 'Mens Casual Premium Slim Fit T-Shirts',
        'price': 22.3,
        'description':
            'Slim-fit style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing.',
        'category': "men's clothing",
        'image': 'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg',
        'rating': {'rate': 4.1, 'count': 259}
      }),
      Product.fromJson({
        'id': 3,
        'title': 'Mens Cotton Jacket',
        'price': 55.99,
        'description':
            'Great outerwear jackets for Spring/Autumn/Winter, suitable for many occasions, such as working, hiking, camping, mountain/rock climbing, cycling, traveling or other outdoors.',
        'category': "men's clothing",
        'image': 'https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg',
        'rating': {'rate': 4.7, 'count': 500}
      }),
      Product.fromJson({
        'id': 4,
        'title': 'Mens Casual Slim Fit',
        'price': 15.99,
        'description':
            'The color could be slightly different between on screen and in practice. Please note that body builds vary by person.',
        'category': "men's clothing",
        'image': 'https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg',
        'rating': {'rate': 2.1, 'count': 430}
      }),
      Product.fromJson({
        'id': 5,
        'title': "John Hardy Women's Legends Naga Gold & Silver Dragon Station Chain Bracelet",
        'price': 695.0,
        'description':
            "From our Legends Collection, the Naga was inspired by the mythical water dragon that protects the ocean's pearl. Wear facing inward to be bestowed with love and abundance.",
        'category': 'jewelery',
        'image': 'https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg',
        'rating': {'rate': 4.6, 'count': 400}
      }),
      Product.fromJson({
        'id': 6,
        'title': 'Solid Gold Petite Micropave',
        'price': 168.0,
        'description':
            'Satisfaction Guaranteed. Return or exchange any order within 30 days. Designed and manufactured by John Hardy.',
        'category': 'jewelery',
        'image': 'https://fakestoreapi.com/img/61sbMiAs0GL._AC_UL640_QL65_ML3_.jpg',
        'rating': {'rate': 3.9, 'count': 70}
      }),
      Product.fromJson({
        'id': 7,
        'title': 'White Gold Plated Princess Ring',
        'price': 9.99,
        'description':
            'Classic Created Wedding Engagement Solitaire Diamond Promise Ring for Her. Gifts to spoil your love more for Engagement, Wedding, Anniversary, Valentine\'s Day...',
        'category': 'jewelery',
        'image': 'https://fakestoreapi.com/img/71YAIFU48IL._AC_UL640_QL65_ML3_.jpg',
        'rating': {'rate': 3.0, 'count': 400}
      }),
      Product.fromJson({
        'id': 8,
        'title': 'Pierced Owl Rose Gold Plated Stainless Steel Double',
        'price': 10.99,
        'description':
            'Rose Gold Plated Double Flared Tunnel Plug Earrings. Made of 316L Stainless Steel.',
        'category': 'jewelery',
        'image': 'https://fakestoreapi.com/img/51UDEzMJVKU._AC_UL640_QL65_ML3_.jpg',
        'rating': {'rate': 1.9, 'count': 100}
      }),
      Product.fromJson({
        'id': 9,
        'title': 'WD 2TB Elements Portable External Hard Drive - USB 3.0',
        'price': 64.0,
        'description':
            'USB 3.0 and USB 2.0 Compatibility Fast data transfers Improve PC Performance High Capacity; Compatibility Formatted NTFS for Windows 10, 8.1, 7.',
        'category': 'electronics',
        'image': 'https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_.jpg',
        'rating': {'rate': 3.3, 'count': 203}
      }),
      Product.fromJson({
        'id': 10,
        'title': 'SanDisk SSD PLUS 1TB Internal SSD - SATA III 6 Gb/s',
        'price': 109.0,
        'description':
            'Easy upgrade for faster boot up, shutdown, application load and response. Boosts burst write performance, making it ideal for typical PC workloads.',
        'category': 'electronics',
        'image': 'https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_.jpg',
        'rating': {'rate': 2.9, 'count': 470}
      }),
    ];
  }
}
