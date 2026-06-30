import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiClient {
  final http.Client _client = http.Client();

  Uri _uri(String path, {String baseUrl = ApiConstants.baseUrl}) =>
      Uri.parse('$baseUrl$path');

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> get(String path) async {
    final candidates = _baseCandidatesFor(path);
    for (final baseUrl in candidates) {
      try {
        final res = await _client
            .get(_uri(path, baseUrl: baseUrl), headers: _headers)
            .timeout(ApiConstants.timeout);
        if (res.statusCode >= 200 && res.statusCode < 300) {
          return _handle(res);
        }
        if (res.statusCode >= 400 && res.statusCode < 500) {
          return _handle(res);
        }
      } catch (_) {
        continue;
      }
    }

    throw ApiException(
      'Erreur réseau : impossible de joindre le serveur. Vérifiez que le backend tourne sur ${ApiConstants.baseUrlForPlatform(isAndroid: Platform.isAndroid)}.',
    );
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final candidates = _baseCandidatesFor(path);
    for (final baseUrl in candidates) {
      try {
        final res = await _client
            .post(
              _uri(path, baseUrl: baseUrl),
              headers: _headers,
              body: jsonEncode(body),
            )
            .timeout(ApiConstants.timeout);
        if (res.statusCode >= 200 && res.statusCode < 300) {
          return _handle(res);
        }
        if (res.statusCode >= 400 && res.statusCode < 500) {
          return _handle(res);
        }
      } catch (_) {
        continue;
      }
    }

    throw ApiException(
      'Erreur réseau : impossible de joindre le serveur. Vérifiez que le backend tourne sur ${ApiConstants.baseUrlForPlatform(isAndroid: Platform.isAndroid)}.',
    );
  }

  List<String> _baseCandidatesFor(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return [path];
    }

    final isAndroid = Platform.isAndroid;
    final primary = ApiConstants.baseUrlForPlatform(isAndroid: isAndroid);
    final fallback = ApiConstants.baseUrlForPlatform(isAndroid: false);
    return [primary, fallback];
  }

  dynamic _handle(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      return jsonDecode(res.body);
    }
    String message = 'Erreur serveur (${res.statusCode})';
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map && decoded['message'] != null) {
        message = decoded['message'];
      }
    } catch (_) {}
    throw ApiException(message, statusCode: res.statusCode);
  }
}
