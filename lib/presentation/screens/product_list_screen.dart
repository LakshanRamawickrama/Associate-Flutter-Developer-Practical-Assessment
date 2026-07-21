import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/product_card.dart';
import '../widgets/product_search_bar.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalogue'),
        actions: [
          // Favourites Filter Badge Button
          IconButton(
            icon: Badge(
              label: Text('${productProvider.favouritesCount}'),
              isLabelVisible: productProvider.favouritesCount > 0,
              child: Icon(
                productProvider.onlyShowFavourites
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: productProvider.onlyShowFavourites ? Colors.redAccent : null,
              ),
            ),
            tooltip: productProvider.onlyShowFavourites
                ? 'Show All Products'
                : 'Show Favourites Only',
            onPressed: () {
              productProvider.toggleOnlyShowFavourites();
            },
          ),
          // Light/Dark Theme Toggle
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
            tooltip: themeProvider.isDarkMode
                ? 'Switch to Light Theme'
                : 'Switch to Dark Theme',
            onPressed: () {
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: ProductSearchBar(
              query: productProvider.searchQuery,
              onChanged: (query) => productProvider.setSearchQuery(query),
              onClear: () => productProvider.clearSearch(),
            ),
          ),

          // Categories Filter Bar
          if (productProvider.status == ProductStatus.success) ...[
            CategoryFilterBar(
              categories: productProvider.categories,
              selectedCategory: productProvider.selectedCategory,
              onSelected: (category) {
                productProvider.selectCategory(category);
              },
            ),
            const SizedBox(height: 8),
          ],

          // Favourites active filter notification banner
          if (productProvider.onlyShowFavourites)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.redAccent.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.redAccent.withAlpha(80)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Showing Favourites Only',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => productProvider.toggleOnlyShowFavourites(),
                    child: const Text(
                      'Show All',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Main Body Content State handling
          Expanded(
            child: Builder(
              builder: (context) {
                if (productProvider.status == ProductStatus.loading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Loading catalog products...',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                if (productProvider.status == ProductStatus.error) {
                  return ErrorStateWidget(
                    errorMessage: productProvider.errorMessage ??
                        'Could not connect to product server.',
                    onRetry: () => productProvider.loadProducts(forceRefresh: true),
                  );
                }

                final products = productProvider.filteredProducts;

                if (products.isEmpty) {
                  if (productProvider.onlyShowFavourites) {
                    return EmptyStateWidget(
                      title: 'No Favourites Yet',
                      message:
                          'Tap the heart icon on any product to save it to your favourites list.',
                      buttonText: 'View All Products',
                      onButtonPressed: () {
                        productProvider.toggleOnlyShowFavourites();
                      },
                    );
                  }

                  return EmptyStateWidget(
                    title: 'No Products Found',
                    message: productProvider.searchQuery.isNotEmpty
                        ? 'No products matched "${productProvider.searchQuery}". Try a different keyword.'
                        : 'No products are currently available in this category.',
                    buttonText: 'Reset Filters',
                    onButtonPressed: () {
                      productProvider.clearSearch();
                      productProvider.selectCategory('All');
                    },
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await productProvider.loadProducts(forceRefresh: true);
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth > 900
                          ? 4
                          : constraints.maxWidth > 600
                              ? 3
                              : 2;

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                            onFavouriteToggle: () {
                              productProvider.toggleFavourite(product.id);
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
