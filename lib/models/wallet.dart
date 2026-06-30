// lib/models/wallet.dart
class Wallet {
  final String phone;
  final double balance;
  final String currency;

  Wallet({required this.phone, required this.balance, this.currency = 'XOF'});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      phone: json['phone'] ?? json['phoneNumber'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'XOF',
    );
  }
}