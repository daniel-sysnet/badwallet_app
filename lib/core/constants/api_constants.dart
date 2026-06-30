class ApiConstants {
  ApiConstants._();

  // Émulateur Android : localhost de la machine hôte = 10.0.2.2
  // Le backend principal tourne sur 8080 et le service de factures sur 8081.
  static const String baseUrl = 'http://10.0.2.2:8080';
  static const String paymentServiceBaseUrl = 'http://10.0.2.2:8081';

  // Wallets
  static String balance(String phone) => '/api/wallets/$phone/balance';
  static String transactions(String phone) =>
      '/api/wallets/$phone/transactions';
  static const String transfer = '/api/wallets/transfer';
  static const String payFactures = '/api/wallets/pay-factures';

  // Factures (fournisseurs externes)
  static String facturesByFournisseur(String fournisseur) =>
      '/api/external/factures/$fournisseur/current';

  static String paymentServiceFacturesByFournisseur(String fournisseur) =>
      '$paymentServiceBaseUrl/api/factures/$fournisseur/current';

  static const Duration timeout = Duration(seconds: 15);
}
