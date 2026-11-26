import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

class ImageCompressor {
  static Future<Uint8List?> compressImage(
    Uint8List imageBytes, {
    int minWidth = 400,
    int minHeight = 400,
    int quality = 60,
  }) async {
    try {
      Uint8List? result;

      try {
        if (!kIsWeb && Platform.isWindows) {
          throw UnimplementedError("Native compress not supported on Windows");
        }

        result = await FlutterImageCompress.compressWithList(
          imageBytes,
          minWidth: minWidth,
          minHeight: minHeight,
          quality: quality,
          format: CompressFormat.webp,
        );
      } catch (e) {
        debugPrint("Native compression skipped ($e). Using Dart fallback.");
      }

      // Fallback to pure-Dart 'image' package (Works on all platforms)
      result ??= await compute(_compressWithDartImage, {
        'bytes': imageBytes,
        'minWidth': minWidth,
        'minHeight': minHeight,
        'quality': quality,
      });

      return result ?? imageBytes;
    } catch (e) {
      debugPrint("Error compressing image: $e");
      return imageBytes;
    }
  }

  static Uint8List? _compressWithDartImage(Map<String, dynamic> params) {
    try {
      final Uint8List bytes = params['bytes'];
      final int minWidth = params['minWidth'];
      final int minHeight = params['minHeight'];
      final int quality = params['quality'];

      final img.Image? decoded = img.decodeImage(bytes);
      if (decoded == null) return null;

      img.Image processed = decoded;
      if (decoded.width > minWidth || decoded.height > minHeight) {
        processed = img.copyResize(
          decoded,
          width: decoded.width > decoded.height ? minWidth : null,
          height: decoded.height >= decoded.width ? minHeight : null,
          interpolation: img.Interpolation.linear,
        );
      }

      return Uint8List.fromList(img.encodeJpg(processed, quality: quality));
    } catch (e) {
      debugPrint("Pure-Dart compression error: $e");
      return null;
    }
  }
}
