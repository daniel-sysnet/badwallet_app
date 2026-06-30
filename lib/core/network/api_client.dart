import 'dart:convert';
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

  Uri _uri(String path) => Uri.parse('${ApiConstants.baseUrl}$path');

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> get(String path) async {
    try {
      final res = await _client
          .get(_uri(path), headers: _headers)
          .timeout(ApiConstants.timeout);
      return _handle(res);
    } catch (e) {
      throw ApiException(
        'Erreur réseau : impossible de joindre le serveur. Vérifiez que le backend tourne sur ${ApiConstants.baseUrl}.',
      );
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    try {
      final res = await _client
          .post(_uri(path), headers: _headers, body: jsonEncode(body))
          .timeout(ApiConstants.timeout);
      return _handle(res);
    } catch (e) {
      throw ApiException(
        'Erreur réseau : impossible de joindre le serveur. Vérifiez que le backend tourne sur ${ApiConstants.baseUrl}.',
      );
    }
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
