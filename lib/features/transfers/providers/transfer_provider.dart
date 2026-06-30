import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/view_state.dart';

class TransferProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  ViewState<Map<String, dynamic>> _state = const ViewState.initial();
  ViewState<Map<String, dynamic>> get state => _state;

  Future<bool> sendTransfer({
    required String phone,
    required String recipient,
    required double amount,
  }) async {
    _state = const ViewState.loading();
    notifyListeners();

    try {
      final response = await _api.post(ApiConstants.transfer, {
        'senderPhone': phone,
        'receiverPhone': recipient,
        'amount': amount,
      });

      final payload = response is Map<String, dynamic>
          ? response
          : {'message': 'Transfert effectué avec succès'};

      _state = ViewState.loaded(payload);
      return true;
    } on ApiException catch (e) {
      _state = ViewState.error(e.message);
      return false;
    } catch (e) {
      _state = ViewState.error('Une erreur inattendue est survenue');
      return false;
    } finally {
      notifyListeners();
    }
  }
}
