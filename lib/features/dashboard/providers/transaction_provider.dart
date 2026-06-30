import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/view_state.dart';
import '../../../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  ViewState<List<AppTransaction>> _state = const ViewState.initial();
  ViewState<List<AppTransaction>> get state => _state;

  Future<void> fetchTransactions(String phone) async {
    _state = const ViewState.loading();
    notifyListeners();
    try {
      final json = await _api.get(ApiConstants.transactions(phone));
      final list = (json is List ? json : <dynamic>[])
          .map((e) => AppTransaction.fromJson(e as Map<String, dynamic>))
          .toList();
      _state = ViewState.loaded(list);
    } on ApiException catch (e) {
      _state = ViewState.error(e.message);
    } catch (e) {
      _state = ViewState.error('Une erreur inattendue est survenue');
    }
    notifyListeners();
  }

  List<AppTransaction> get last5 {
    final data = state.data ?? [];
    final sorted = [...data]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }
}