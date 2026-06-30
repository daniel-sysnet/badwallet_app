// lib/models/facture.dart
class Facture {
  final String id;
  final String fournisseur; // ISM, WOYAFAL, RAPIDO, SENELEC...
  final double montant;
  final DateTime echeance;
  final String reference;
  bool selected; // état UI pour la sélection multiple

  Facture({
    required this.id,
    required this.fournisseur,
    required this.montant,
    required this.echeance,
    required this.reference,
    this.selected = false,
  });

  factory Facture.fromJson(Map<String, dynamic> json, String fournisseur) {
    return Facture(
      id: json['id'].toString(),
      fournisseur: fournisseur,
      montant: (json['montant'] ?? json['amount'] ?? 0).toDouble(),
      echeance: DateTime.tryParse(json['echeance'] ?? json['dueDate'] ?? '') ?? DateTime.now(),
      reference: json['reference'] ?? json['ref'] ?? '',
    );
  }
}