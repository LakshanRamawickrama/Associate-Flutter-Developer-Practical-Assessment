import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_catalogue/core/theme/theme_provider.dart';
import 'package:product_catalogue/data/models/product.dart';
import 'package:product_catalogue/data/repositories/product_repository.dart';
import 'package:product_catalogue/data/services/storage_service.dart';
import 'package:product_catalogue/presentation/providers/product_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProductModel & Provider Unit Tests', () {
    test('Product.fromJson parses valid JSON data correctly', () {
      final json = {
        'id': 100,
        'title': 'Test Backpack',
        'price': 49.99,
        'description': 'A durable test backpack',
        'category': 'accessories',
        'image': 'https://example.com/image.jpg',
        'rating': {'rate': 4.5, 'count': 88}
      };

      final product = Product.fromJson(json);

      expect(product.id, 100);
      expect(product.title, 'Test Backpack');
      expect(product.price, 49.99);
      expect(product.category, 'accessories');
      expect(product.rating.rate, 4.5);
      expect(product.isFavourite, false);
    });

    test('ProductProvider search filtering works for substring matching', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storageService = StorageService(prefs);
      final repository = ProductRepository();

      final provider = ProductProvider(
        repository: repository,
        storageService: storageService,
      );

      await provider.loadProducts();

      expect(provider.status, ProductStatus.success);
      expect(provider.filteredProducts.isNotEmpty, true);

      // Search matching "backpack"
      provider.setSearchQuery('backpack');
      expect(
        provider.filteredProducts.every(
          (p) => p.title.toLowerCase().contains('backpack') || p.category.toLowerCase().contains('backpack'),
        ),
        true,
      );
    });

    test('ProductProvider favourite toggling and persistence work', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storageService = StorageService(prefs);
      final repository = ProductRepository();

      final provider = ProductProvider(
        repository: repository,
        storageService: storageService,
      );

      await provider.loadProducts();

      expect(provider.isFavourite(1), false);
      await provider.toggleFavourite(1);
      expect(provider.isFavourite(1), true);

      // Verify persistence in storage
      expect(storageService.getFavouriteProductIds().contains(1), true);

      await provider.toggleFavourite(1);
      expect(provider.isFavourite(1), false);
      expect(storageService.getFavouriteProductIds().contains(1), false);
    });

    test('ThemeProvider toggles light and dark modes', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storageService = StorageService(prefs);

      final themeProvider = ThemeProvider(storageService);

      expect(themeProvider.isDarkMode, false);
      await themeProvider.toggleTheme(true);
      expect(themeProvider.isDarkMode, true);
      expect(storageService.getIsDarkMode(), true);
    });
  });
}
