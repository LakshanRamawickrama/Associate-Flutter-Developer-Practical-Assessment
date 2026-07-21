import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  static const String _favouritesKey = 'favourite_product_ids';
  static const String _darkModeKey = 'is_dark_mode';

  StorageService(this._prefs);

  // Favourites Persistence
  List<int> getFavouriteProductIds() {
    final StringList = _prefs.getStringList(_favouritesKey) ?? [];
    return StringList.map((id) => int.tryParse(id)).whereType<int>().toList();
  }

  Future<bool> saveFavouriteProductIds(List<int> favouriteIds) async {
    final StringList = favouriteIds.map((id) => id.toString()).toList();
    return await _prefs.setStringList(_favouritesKey, StringList);
  }

  // Theme Persistence
  bool? getIsDarkMode() {
    return _prefs.getBool(_darkModeKey);
  }

  Future<bool> setIsDarkMode(bool isDark) async {
    return await _prefs.setBool(_darkModeKey, isDark);
  }
}
