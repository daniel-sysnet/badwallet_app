import 'package:badwallet_app/models/wallet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Wallet.fromJson parses a numeric balance response', () {
    final wallet = Wallet.fromJson(100000.0);

    expect(wallet.balance, 100000.0);
    expect(wallet.currency, 'XOF');
  });

  test('Wallet.fromJson parses a map response', () {
    final wallet = Wallet.fromJson({
      'balance': 25000,
      'phone': '+221770000001',
    });

    expect(wallet.balance, 25000.0);
    expect(wallet.phone, '+221770000001');
  });
}
