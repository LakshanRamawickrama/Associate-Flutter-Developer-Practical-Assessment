import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  static const String _favouritesKey = 'favourite_product_ids';
  static const String _darkModeKey = 'is_dark_mode';

  StorageService(this._prefs);

  // Favourites Persistence
  List<int> getFavouriteProductIds() {
    final stringList = _prefs.getStringList(_favouritesKey) ?? [];
    return stringList.map((id) => int.tryParse(id)).whereType<int>().toList();
  }

  Future<bool> saveFavouriteProductIds(List<int> favouriteIds) async {
    final stringList = favouriteIds.map((id) => id.toString()).toList();
    return await _prefs.setStringList(_favouritesKey, stringList);
  }

  // Theme Persistence
  bool? getIsDarkMode() {
    return _prefs.getBool(_darkModeKey);
  }

  Future<bool> setIsDarkMode(bool isDark) async {
    return await _prefs.setBool(_darkModeKey, isDark);
  }
}
