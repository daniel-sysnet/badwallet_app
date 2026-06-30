import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  static const _phoneKey = 'user_phone';

  String? _phone;
  bool _isLoading = true;

  String? get phone => _phone;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _phone != null && _phone!.isNotEmpty;

  AuthProvider() {
    _loadPhone();
  }

  Future<void> _loadPhone() async {
    _phone = await _storage.read(key: _phoneKey);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setPhone(String phone) async {
    _phone = phone;
    await _storage.write(key: _phoneKey, value: phone);
    notifyListeners();
  }

  Future<void> logout() async {
    _phone = null;
    await _storage.delete(key: _phoneKey);
    notifyListeners();
  }
}