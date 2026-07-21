import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/services/storage_service.dart';

enum ProductStatus { initial, loading, success, error }

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;
  final StorageService _storageService;

  ProductStatus _status = ProductStatus.initial;
  String? _errorMessage;
  List<Product> _allProducts = [];
  Set<int> _favouriteIds = {};
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _onlyShowFavourites = false;

  ProductProvider({
    required ProductRepository repository,
    required StorageService storageService,
  })  : _repository = repository,
        _storageService = storageService {
    _loadFavouritesFromStorage();
  }

  // Getters
  ProductStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get onlyShowFavourites => _onlyShowFavourites;
  Set<int> get favouriteIds => _favouriteIds;

  List<String> get categories {
    final categorySet = _allProducts.map((p) => p.category).toSet();
    return ['All', ...categorySet];
  }

  List<Product> get filteredProducts {
    return _allProducts.where((product) {
      // Search filter
      final matchesSearch = _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase());

      // Category filter
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;

      // Favourite filter
      final matchesFavourite =
          !_onlyShowFavourites || _favouriteIds.contains(product.id);

      return matchesSearch && matchesCategory && matchesFavourite;
    }).map((product) {
      return product.copyWith(
        isFavourite: _favouriteIds.contains(product.id),
      );
    }).toList();
  }

  int get favouritesCount => _favouriteIds.length;

  void _loadFavouritesFromStorage() {
    _favouriteIds = _storageService.getFavouriteProductIds().toSet();
  }

  Future<void> loadProducts({bool forceRefresh = false}) async {
    _status = ProductStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final products = await _repository.getProducts(forceRefresh: forceRefresh);
      _allProducts = products;
      _status = ProductStatus.success;
    } catch (e) {
      _status = ProductStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleOnlyShowFavourites() {
    _onlyShowFavourites = !_onlyShowFavourites;
    notifyListeners();
  }

  Future<void> toggleFavourite(int productId) async {
    if (_favouriteIds.contains(productId)) {
      _favouriteIds.remove(productId);
    } else {
      _favouriteIds.add(productId);
    }
    await _storageService.saveFavouriteProductIds(_favouriteIds.toList());
    notifyListeners();
  }

  bool isFavourite(int productId) {
    return _favouriteIds.contains(productId);
  }
}
