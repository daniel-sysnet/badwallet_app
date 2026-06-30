import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/view_state.dart';
import '../../../models/wallet.dart';

class WalletProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  ViewState<Wallet> _state = const ViewState.initial();
  ViewState<Wallet> get state => _state;

  bool _balanceVisible = true;
  bool get balanceVisible => _balanceVisible;

  void toggleBalanceVisibility() {
    _balanceVisible = !_balanceVisible;
    notifyListeners();
  }

  Future<void> fetchBalance(String phone) async {
    _state = const ViewState.loading();
    notifyListeners();
    try {
      final json = await _api.get(ApiConstants.balance(phone));
      final wallet = Wallet.fromJson(json is Map<String, dynamic> ? json : {});
      _state = ViewState.loaded(wallet);
    } on ApiException catch (e) {
      _state = ViewState.error(e.message);
    } catch (e) {
      _state = ViewState.error('Une erreur inattendue est survenue');
    }
    notifyListeners();
  }
}