import 'package:dio/dio.dart';

import '../../../core/networking/api_link.dart';
import '../helpers/constants/constants.dart';

class Network {
  static Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrlApi,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  static Map<String, dynamic>? _toQueryMap(dynamic query) {
    if (query == null) return null;
    if (query is Map<String, dynamic>) {
      return query.isEmpty ? null : query;
    }
    if (query is Map) {
      final converted = Map<String, dynamic>.from(query);
      return converted.isEmpty ? null : converted;
    }
    return null;
  }

  static Future<Response> getData(String url) async {
    return await dio.get(url, options: Options(headers: myHeaders));
  }

  static Future<Response> postData(String url) async {
    return await dio.post(url, options: Options(headers: myHeaders));
  }

  static Future<Response> postDataWithQuery(var jsonQuery, String url) async {
    return await dio.post(
      url,
      queryParameters: _toQueryMap(jsonQuery),
      options: Options(headers: myHeaders),
    );
  }

  static Future<Response> putDataWithBody(var jsonData, String url) async {
    return await dio.put(
      url,
      data: jsonData,
      options: Options(headers: myHeaders),
    );
  }

  static Future<Response> putDataWithBodyAndParams(
      var jsonData, var jsonQuery, String url) async {
    return await dio.put(
      url,
      data: jsonData,
      queryParameters: _toQueryMap(jsonQuery),
      options: Options(headers: myHeaders),
    );
  }

  static Future<Response> deleteData(var jsonQuery, String url) async {
    return await dio.delete(
      url,
      options: Options(headers: myHeaders),
      queryParameters: _toQueryMap(jsonQuery),
    );
  }

  static Future<Response> deleteDataWithBody(var jsonData, String url) async {
    return await dio.delete(
      url,
      data: jsonData,
      options: Options(headers: myHeaders),
    );
  }

  static Future<Response> deleteDataWithBodyAndParams(
      var jsonData, var jsonQuery, String url) async {
    return await dio.delete(
      url,
      data: jsonData,
      queryParameters: _toQueryMap(jsonQuery),
      options: Options(headers: myHeaders),
    );
  }

  static Future<Response> getDataWithBodyAndParams(
      var jsonData, var jsonQuery, String url) async {
    return await dio.get(
      url,
      data: jsonData,
      options: Options(headers: myHeaders),
      queryParameters: _toQueryMap(jsonQuery),
    );
  }

  static Future<Response> getDataWithParams(
      dynamic jsonQuery, String url) async {
    return await dio.get(
      url,
      options: Options(headers: myHeaders),
      queryParameters: _toQueryMap(jsonQuery),
    );
  }

  static Future<Response> getDataWithBody(var jsonData, String url) async {
    return await dio.get(
      url,
      data: jsonData,
      options: Options(headers: myHeaders),
    );
  }

  static Future<Response> postDataWithBody(var jsonData, String url) async {
    return await dio.post(
      url,
      data: jsonData,
      options: Options(headers: myHeaders),
    );
  }

  static Future<Response> postDataWithBodyAndParams(
      var jsonData, var jsonQuery, String url) async {
    return await dio.post(
      url,
      data: jsonData,
      queryParameters: _toQueryMap(jsonQuery),
      options: Options(headers: myHeaders),
    );
  }
}
