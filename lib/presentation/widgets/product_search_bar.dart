import 'package:flutter/material.dart';

class ProductSearchBar extends StatelessWidget {
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const ProductSearchBar({
    super.key,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: TextEditingController.fromValue(
        TextEditingValue(
          text: query,
          selection: TextSelection.collapsed(offset: query.length),
        ),
      ),
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search products by name or category...',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: query.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded),
                onPressed: onClear,
                tooltip: 'Clear search',
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
