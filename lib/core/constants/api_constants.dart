class ApiConstants {
  ApiConstants._();

  static String baseUrlForPlatform({required bool isAndroid}) {
    return isAndroid ? 'http://10.0.2.2:8080' : 'http://127.0.0.1:8080';
  }

  static String paymentServiceBaseUrlForPlatform({required bool isAndroid}) {
    return isAndroid ? 'http://10.0.2.2:8081' : 'http://127.0.0.1:8081';
  }

  static const String baseUrl = 'http://10.0.2.2:8080';
  static const String paymentServiceBaseUrl = 'http://10.0.2.2:8081';

  // Wallets
  static String wallet(String phone) => '/api/wallets/$phone';
  static String balance(String phone) => '/api/wallets/$phone/balance';
  static String transactions(String phone) =>
      '/api/wallets/$phone/transactions';
  static const String transfer = '/api/wallets/transfer';
  static const String payFactures = '/api/wallets/pay-factures';

  // Factures (proxy backend)
  static String facturesByFournisseur(String fournisseur) =>
      '/api/external/factures/$fournisseur/current';

  static String facturesByWalletCode(String walletCode, {String? unite}) {
    final query = unite == null || unite.isEmpty
        ? ''
        : '?unite=${Uri.encodeComponent(unite)}';
    return '/api/external/factures/$walletCode/current$query';
  }

  static const Duration timeout = Duration(seconds: 15);
}
