import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingService {
  GeocodingService._();
  static final GeocodingService instance = GeocodingService._();

  static const String _userAgent =
      'san_web_admin_app/1.0 (support@sanmotorss.com)';

  final Map<String, String> _cache = {};

  Future<String?> reverseGeocode({
    required double latitude,
    required double longitude,
    bool isArabic = true,
  }) async {
    final lang = isArabic ? 'ar' : 'en';
    final key =
        '${latitude.toStringAsFixed(5)},${longitude.toStringAsFixed(5)}_$lang';
    if (_cache.containsKey(key)) {
      return _cache[key];
    }

    final url =
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$latitude&lon=$longitude&accept-language=$lang';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': _userAgent,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String? displayName = data['display_name'] as String?;
        if (displayName != null && displayName.isNotEmpty) {
          _cache[key] = displayName;
          return displayName;
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
