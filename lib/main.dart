import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'data/repositories/product_repository.dart';
import 'data/services/api_service.dart';
import 'data/services/storage_service.dart';
import 'presentation/providers/product_provider.dart';
import 'presentation/screens/product_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences & Services
  final sharedPreferences = await SharedPreferences.getInstance();
  final storageService = StorageService(sharedPreferences);
  final apiService = ApiService();
  final productRepository = ProductRepository(apiService: apiService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(
            repository: productRepository,
            storageService: storageService,
          ),
        ),
      ],
      child: const ProductCatalogueApp(),
    ),
  );
}

class ProductCatalogueApp extends StatelessWidget {
  const ProductCatalogueApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Product Catalogue',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const ProductListScreen(),
    );
  }
}
