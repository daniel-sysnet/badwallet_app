// lib/models/wallet.dart
class Wallet {
  final String phone;
  final double balance;
  final String currency;

  Wallet({required this.phone, required this.balance, this.currency = 'XOF'});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    final dynamic balanceValue =
        json['balance'] ?? json['solde'] ?? json['amount'] ?? 0;
    final dynamic currencyValue = json['currency'] ?? 'XOF';

    return Wallet(
      phone: json['phone'] ?? json['phoneNumber'] ?? '',
      balance: balanceValue is num ? balanceValue.toDouble() : 0.0,
      currency: currencyValue is String ? currencyValue : 'XOF',
    );
  }
}
