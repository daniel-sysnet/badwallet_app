// lib/models/transaction.dart
enum TransactionType { sent, received, deposit, withdrawal, payment }

class AppTransaction {
  final String id;
  final TransactionType type;
  final double amount;
  final String? counterparty; // numéro destinataire/expéditeur
  final DateTime date;
  final String? label; // ex: nom du fournisseur pour un paiement

  AppTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.counterparty,
    this.label,
  });

  factory AppTransaction.fromJson(Map<String, dynamic> json) {
    return AppTransaction(
      id: json['id'].toString(),
      type: _parseType(json['type'] ?? ''),
      amount: (json['amount'] ?? 0).toDouble(),
      counterparty: json['counterparty'] ?? json['recipient'] ?? json['sender'],
      date: DateTime.tryParse(json['date'] ?? json['createdAt'] ?? '') ?? DateTime.now(),
      label: json['label'] ?? json['description'],
    );
  }

  static TransactionType _parseType(String raw) {
    switch (raw.toLowerCase()) {
      case 'sent':
      case 'transfer_out':
        return TransactionType.sent;
      case 'received':
      case 'transfer_in':
        return TransactionType.received;
      case 'deposit':
        return TransactionType.deposit;
      case 'withdrawal':
        return TransactionType.withdrawal;
      case 'payment':
      case 'facture':
        return TransactionType.payment;
      default:
        return TransactionType.sent;
    }
  }

  bool get isOutgoing =>
      type == TransactionType.sent ||
      type == TransactionType.withdrawal ||
      type == TransactionType.payment;
}