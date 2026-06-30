import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/view_state.dart';
import '../../../models/facture.dart';

class BillsProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  ViewState<List<Facture>> _state = const ViewState.initial();
  ViewState<List<Facture>> get state => _state;

  List<Facture> _factures = [];
  List<Facture> get factures => _factures;

  Future<void> fetchFactures(String fournisseur) async {
    _state = const ViewState.loading();
    notifyListeners();

    try {
      final json = await _api.get(
        ApiConstants.facturesByFournisseur(fournisseur),
      );
      final payload = json is Map<String, dynamic> ? json : <String, dynamic>{};
      final rawFactures = payload['factures'] is List
          ? payload['factures'] as List<dynamic>
          : <dynamic>[];
      final list = rawFactures
          .map((e) => Facture.fromJson(e as Map<String, dynamic>, fournisseur))
          .toList();
      _factures = list;
      _state = ViewState.loaded(list);
    } on ApiException catch (e) {
      _state = ViewState.error(e.message);
    } catch (e) {
      _state = ViewState.error('Une erreur inattendue est survenue');
    } finally {
      notifyListeners();
    }
  }

  Future<bool> payFactures({
    required String phone,
    required List<Facture> selected,
  }) async {
    if (selected.isEmpty) return false;

    _state = const ViewState.loading();
    notifyListeners();

    try {
      await _api.post(ApiConstants.payFactures, {
        'phoneNumber': phone,
        'serviceName': selected.first.fournisseur,
        'factureReferences': selected
            .map(
              (facture) =>
                  facture.reference.isNotEmpty ? facture.reference : facture.id,
            )
            .toList(),
      });
      _state = ViewState.loaded([..._factures]);
      return true;
    } on ApiException catch (e) {
      _state = ViewState.error(e.message);
      return false;
    } catch (e) {
      _state = ViewState.error('Le paiement a échoué');
      return false;
    } finally {
      notifyListeners();
    }
  }
}
