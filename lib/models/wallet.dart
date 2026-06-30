// lib/models/wallet.dart
class Wallet {
  final String phone;
  final double balance;
  final String currency;

  Wallet({required this.phone, required this.balance, this.currency = 'XOF'});

  factory Wallet.fromJson(dynamic json) {
    if (json is num) {
      return Wallet(phone: '', balance: json.toDouble(), currency: 'XOF');
    }

    if (json is String) {
      final parsed = double.tryParse(
        json.replaceAll(RegExp(r'[^0-9,.-]'), '').replaceAll(',', '.'),
      );
      return Wallet(phone: '', balance: parsed ?? 0.0, currency: 'XOF');
    }

    final map = json is Map
        ? Map<String, dynamic>.from(json)
        : <String, dynamic>{};
    final dynamic balanceValue =
        map['balance'] ?? map['solde'] ?? map['amount'] ?? 0;
    final dynamic currencyValue = map['currency'] ?? 'XOF';

    return Wallet(
      phone: map['phone'] ?? map['phoneNumber'] ?? '',
      balance: balanceValue is num ? balanceValue.toDouble() : 0.0,
      currency: currencyValue is String ? currencyValue : 'XOF',
    );
  }
}
