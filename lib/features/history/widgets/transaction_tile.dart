import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final AppTransaction transaction;
  const TransactionTile({super.key, required this.transaction});

  String _typeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.sent:
        return 'Transfert envoyé';
      case TransactionType.received:
        return 'Transfert reçu';
      case TransactionType.deposit:
        return 'Dépôt';
      case TransactionType.withdrawal:
        return 'Retrait';
      case TransactionType.payment:
        return 'Paiement facture';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOut = transaction.isOutgoing;
    final color = isOut ? AppColors.danger : AppColors.success;
    final currencyFmt = NumberFormat.decimalPattern('fr_FR');

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(
          isOut ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
          color: color,
        ),
      ),
      title: Text(transaction.label ?? _typeLabel(transaction.type)),
      subtitle: Text(
        transaction.counterparty ?? DateFormat('dd/MM/yyyy HH:mm').format(transaction.date),
      ),
      trailing: Text(
        '${isOut ? '-' : '+'}${currencyFmt.format(transaction.amount)} XOF',
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}